import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/page_list_tile/patient_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_list/patient_add_list.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAllListPage extends StatelessWidget {
  const PatientAllListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    return Scaffold(
      appBar: PatientAppBar(title: "Hasta Kaydı"),
      body: Padding(
        padding: mainPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<PatientAddViewmodel>(
              builder: (context, viewModel, _) {
                return Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: 4.h),
                      PatientAddList(idController: idController),
                      SizedBox(height: 3.h),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                if (index == 0) SizedBox(height: 2.h),
                                PatientListTile(),
                              ],
                            );
                          },
                          itemCount: 2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
