import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodels/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
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
                return Column(
                  children: [
                    InformationBox(
                      showCopy: false,
                      padding: EdgeInsets.only(
                        top: 1.h,
                        bottom: 1.h,
                        left: 4.w,
                        right: 4.w,
                      ),
                      textFieldListTiles: [
                        TextFieldListTile(
                          title: "ID",
                          controller: idController,
                        ),
                      ],
                      buttonWidget: SecondButton(
                        buttonText: "Mevcut Hasta Ekle",
                        onPressed: () {},
                        height: 4.h,
                      ),
                    ),
                    SizedBox(height: 3.h),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
