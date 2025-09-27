import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAddPage extends StatelessWidget {
  const PatientAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final protocolNumber = TextEditingController();
    return ChangeNotifierProvider(
      create: (_) => PatientAddViewmodel(context.read<PatientViewModel>()),
      child: Scaffold(
        appBar: PatientAppBar(title: "Hasta Kaydı"),
        body: Padding(
          padding: mainPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              PageInformationBox(title: "Yeni Hasta Kaydı Oluşturun"),
              SizedBox(height: 0.5.h),
              Text(
                "Hasta ID'sini paylaşmak için kopyala veya paylaş butonlarını kullanabilirsiniz.",
                textAlign: TextAlign.center,
                style: AppTextStyles.nunitoLight15.copyWith(
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 2.h),
              Consumer<PatientAddViewmodel>(
                builder: (context, viewModel, _) {
                  return Column(
                    children: [
                      InformationBox(
                        title: "HASTA",
                        showCopy: false,
                        textFieldListTiles: [
                          TextFieldListTile(
                            title: "Adı",
                            controller: nameController,
                          ),
                          TextFieldListTile(
                            title: "Soyadı",
                            controller: surnameController,
                          ),
                          TextFieldListTile(
                            title: "Protokol\nNo",
                            controller: protocolNumber,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      SecondButton(
                        buttonText: "KAYDI OLUŞTUR",
                        onPressed: () => viewModel.addPatient(
                          context: context,
                          name: nameController.text.trim(),
                          surname: surnameController.text.trim(),
                          protocolNo: protocolNumber.text.trim(),
                        ),
                        height: 5.5.h,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
