import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/constants/paddings.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_data_viewmodel.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/fixed_list_tile.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/information_box/information_box.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/widgets/patient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PatientViewData extends StatelessWidget {
  final String? patientId;
  final String categoryKey;

  const PatientViewData({super.key, this.patientId, required this.categoryKey});

  /// Kategoriye ait alan adlarını ve değerlerini FixedListTile olarak döndürür.
  List<FixedListTile> _getCategoryTiles(PatientViewDataViewmodel viewModel) {
    final data = viewModel.getCategoryData(categoryKey);
    if (data == null || data.isEmpty) {
      // Veri yoksa placeholder göster
      return [FixedListTile(title: "HATA", field: "HATA")];
    }
    // Her bir alan için: title = alan adı, field = alan değeri
    return data.entries
        .map((e) => FixedListTile(title: e.key, field: e.value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final cardData = CategoryCardData.getCategoryById(categoryKey);
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
                          return Column(
                            children: [
                              SizedBox(height: 3.h),
                              InformationBox(
                                innerPadding: EdgeInsets.only(bottom: 1.h),
                                showCopy: false,
                                title: "${cardData.name} Verileri",
                                fixedListTiles: _getCategoryTiles(viewModel),
                              ),
                            ],
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
