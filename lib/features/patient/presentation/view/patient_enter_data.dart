import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/theme/theme_color.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_enter_data_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/page_information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_enter/data_list.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientEnterData extends StatelessWidget {
  final String? patientId;

  const PatientEnterData({super.key, this.patientId});

  @override
  Widget build(BuildContext context) {
    // Route arguments'dan patientId'yi al
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final finalPatientId = patientId ?? args?['patientId'];

    return ChangeNotifierProvider(
      create: (_) => PatientEnterDataViewModel(),
      child: Builder(
        builder: (context) {
          if (finalPatientId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<PatientEnterDataViewModel>().loadPatientById(
                finalPatientId,
                context,
              );
            });
          }

          return Scaffold(
            appBar: PatientAppBar(title: "Hasta Bilgileri"),
            body: Padding(
              padding: mainPadding,
              child: Consumer<PatientEnterDataViewModel>(
                builder: (context, viewModel, child) {
                  final patient = viewModel.currentPatient;
                  if (patient == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  Map<String, dynamic> addedCategoriesMap =
                      patient.addedCategories?.toMap() ?? {};
                  List<CategoryCardData> finishedCategoriesCard = [];
                  List<CategoryCardData> nonfinishedCategoriesCard = [];
                  for (CategoryCardData category
                      in CategoryCardData.getAllCardCategories()) {
                    if (addedCategoriesMap[category.id] == true) {
                      finishedCategoriesCard.add(category);
                    } else {
                      nonfinishedCategoriesCard.add(category);
                    }
                  }
                  return Column(
                    children: [
                      SizedBox(height: 2.h),
                      InformationBox(
                        padding: EdgeInsets.only(
                          top: 2.5.h,
                          left: 2.w,
                          right: 2.w,
                          bottom: 0.h,
                        ),
                        innerPadding: EdgeInsets.only(bottom: 0.5.h),
                        showCopy: true,
                        title: "HASTA BİLGİLERİ",
                        fixedListTiles: [
                          FixedListTile(
                            title: "ID",
                            field: patient.docId ?? "Yükleniyor...",
                          ),
                          FixedListTile(title: "Adı", field: patient.firstName),
                          FixedListTile(
                            title: "Soyadı",
                            field: patient.lastName,
                          ),
                          FixedListTile(
                            title: "Protokol\nNo",
                            field: patient.protocolNo,
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (nonfinishedCategoriesCard.isNotEmpty)
                                Column(
                                  children: [
                                    PageInformationBox(title: "Bekleyen"),
                                    SizedBox(height: 1.h),
                                    DataList(
                                      isFin: true,
                                      patientID: patient.docId ?? "",
                                      categoryCardData: [
                                        ...nonfinishedCategoriesCard,
                                      ],
                                    ),
                                    SizedBox(height: 1.5.h),
                                  ],
                                ),
                              if (finishedCategoriesCard.isNotEmpty)
                                Column(
                                  children: [
                                    PageInformationBox(title: "Tamamlanmış"),

                                    SizedBox(height: 1.h),
                                    SecondButton(
                                      buttonText: "TÜMÜNÜ GÖRÜNTÜLE",
                                      onPressed: () {},
                                      height: 5.h,
                                      buttonColor: AppColors.thirdButtonColor,
                                    ),
                                    SizedBox(height: 1.h),
                                    DataList(
                                      isFin: false,
                                      patientID: patient.docId ?? "",
                                      categoryCardData: [
                                        ...finishedCategoriesCard,
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
