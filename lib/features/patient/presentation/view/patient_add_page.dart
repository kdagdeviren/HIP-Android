import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/text_theme.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_add_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/text_field_list_tile.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientAddPage extends StatefulWidget {
  const PatientAddPage({super.key});

  @override
  State<PatientAddPage> createState() => _PatientAddPageState();
}

class _PatientAddPageState extends State<PatientAddPage> {
  late final TextEditingController nameController;
  late final TextEditingController surnameController;
  late final TextEditingController protocolNumber;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    protocolNumber = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    protocolNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        showCopy: true,
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
                        onPressed: () async {
                          final response = await viewModel.addPatient(
                            name: nameController.text.trim(),
                            surname: surnameController.text.trim(),
                            protocolNo: protocolNumber.text.trim(),
                          );

                          if (mounted) {
                            if (response.status) {
                              NavigationService.instance.goBack();
                              NavigationService.instance.navigateTo(
                                '/patient-all-list',
                              );
                              ErrorHandler.showSuccessSnackBar(
                                context,
                                "Hasta başarıyla eklendi.",
                              );
                            } else {
                              ErrorHandler.showErrorSnackBar(
                                context,
                                response.message,
                              );
                            }
                          }
                        },
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
