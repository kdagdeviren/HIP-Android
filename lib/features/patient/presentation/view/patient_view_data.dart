import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_data_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_info_box.dart';
import 'package:flutter_medical_data_app/shared/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientViewData extends StatelessWidget {
  final String? patientId;
  final String categoryKey;

  const PatientViewData({super.key, this.patientId, required this.categoryKey});

  /// Kategoriye ait alan adlarını ve değerlerini FixedListTile olarak döndürür.
  List<FixedListTile> _getCategoryTiles(
    PatientViewDataViewmodel viewModel,
    String _categoryKey,
  ) {
    final data = viewModel.getCategoryData(_categoryKey);
    if (data == null || data.isEmpty) {
      // Veri yoksa placeholder göster
      return [];
    }

    return data.entries
        .map((e) => FixedListTile(title: e.key, field: e.value.toString()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    late final allCardData;
    late final cardData;
    if (categoryKey == "all") {
      allCardData = CategoryCardData.getAllCardCategories();
    } else {
      cardData = CategoryCardData.getCategoryById(categoryKey);
    }
    final patientViewModel = Provider.of<PatientViewModel>(
      context,
      listen: false,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PatientViewDataViewmodel(
            patientId: patientId,
            patientViewModel: patientViewModel,
          ),
        ),
      ],
      child: Scaffold(
        appBar: PatientAppBar(title: "Bilgileri Gör"),
        body: Padding(
          padding: mainPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<PatientViewDataViewmodel>(
                        builder: (context, viewModel, child) {
                          if (viewModel.isLoading) {
                            return Center(child: CircularProgressIndicator());
                          }

                          // Patient null kontrolü ekle
                          if (viewModel.patient == null) {
                            return Center(
                              child: Text(
                                'Hasta bilgisi yüklenemedi',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 3.h),
                                PatientInfoBox(patient: viewModel.patient!),
                                SizedBox(height: 3.h),
                                if (categoryKey == "all")
                                  ...allCardData.map((cardData) {
                                    return Column(
                                      children: [
                                        InformationBox(
                                          innerPadding: EdgeInsets.only(
                                            bottom: 1.h,
                                          ),
                                          showCopy: false,
                                          title: "${cardData.name} Verileri",
                                          divider: true,
                                          fixedListTiles: _getCategoryTiles(
                                            viewModel,
                                            cardData.id,
                                          ),
                                        ),
                                        SizedBox(height: 3.h),
                                      ],
                                    );
                                  }).toList()
                                else
                                  InformationBox(
                                    innerPadding: EdgeInsets.only(bottom: 1.h),
                                    showCopy: false,
                                    title: "${cardData.name} Verileri",
                                    divider: true,
                                    fixedListTiles: _getCategoryTiles(
                                      viewModel,
                                      cardData.id,
                                    ),
                                  ),
                                SizedBox(height: 3.h),
                                SecondButton(
                                  buttonText: (categoryKey == "all")
                                      ? "ÇIKTI AL"
                                      : "GÜNCELLE",
                                  onPressed: () async {
                                    if (categoryKey == "all") {
                                      final result = await viewModel
                                          .exportToXlsx();

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(result.message),
                                            backgroundColor: result.success
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        );
                                      }
                                    } else {
                                      NavigationService.instance.navigateTo(
                                        '/patient-update-data',
                                        arguments: {
                                          'navigationFrom': 'updateData',
                                          'patientId': patientId,
                                          'categoryKey': categoryKey,
                                          'patient': viewModel.patient!
                                              .toJsonString(),
                                        },
                                      );
                                    }
                                  },
                                  height: 6.h,
                                ),
                                SizedBox(height: 3.h),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
