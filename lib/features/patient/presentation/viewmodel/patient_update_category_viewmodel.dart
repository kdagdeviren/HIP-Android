import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientUpdateCategoryViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  final String categoryKey;
  final String? patientId;
  Map<String, dynamic> selectedValues = {};

  PatientUpdateCategoryViewmodel(
    this.patientViewModel,
    this.categoryKey,
    this.patientId,
  );

  CategoryCardData get categoryCardData =>
      CategoryCardData.getCategoryById(categoryKey);

  List<Map<String, dynamic>>? get dropdownConfigs {
    switch (categoryKey) {
      case 'pathology':
        return Pathology.getDropdownConfigs();
      case 'oncology':
        return Oncology.getDropdownConfigs();
      case 'demography':
        return Demography.getDropdownConfigs();
      case 'comorbidity':
        return Comorbidity.getDropdownConfigs();
      case 'biochemistry':
        return Biochemistry.getDropdownConfigs();
      case 'radiology':
        return Radiology.getDropdownConfigs();
      case 'pet':
        return PET.getDropdownConfigs();
      default:
        return null;
    }
  }

  void updateValue(String key, dynamic value) {
    selectedValues[key] = value;
    notifyListeners();
  }

  Future<void> save(BuildContext context) async {
    if (patientId == null) {
      LoggerUtil.e('Patient ID is null, cannot save category data');
      return;
    }

    try {
      loading.show(context);

      // Convert selectedValues to Map<String, String>
      Map<String, String> categoryData = {};
      selectedValues.forEach((key, value) {
        if (value is Enum) {
          categoryData[key] = value.name;
        } else {
          categoryData[key] = value.toString();
        }
      });

      // Update only this category in Firestore
      final response = await patientViewModel.updatePatientCategory(
        patientId!,
        categoryKey,
        categoryData,
      );

      if (response.status) {
        loading.close();
        LoggerUtil.i(
          'Category $categoryKey updated successfully for patient $patientId',
        );
        NavigationService.instance.goBack();
        PopupService().showSuccess(context, "Başarılı", "Güncelleme başarılı");
      } else {
        loading.close();
        LoggerUtil.e('Failed to update category: ${response.message}');
        PopupService().showError(context, "HATA", response.message);
      }
    } catch (e) {
      loading.close();
      LoggerUtil.e('Error saving category data: $e');
      PopupService().showError(context, "HATA", e.toString());
    }
  }
}
