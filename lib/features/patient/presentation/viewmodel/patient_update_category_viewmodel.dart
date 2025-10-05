import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientUpdateCategoryViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  final String categoryKey;
  final String? patientId;
  final String? patientJson;
  Map<String, dynamic> selectedValues = {};
  bool _isInitialized = false;

  PatientUpdateCategoryViewmodel(
    this.patientViewModel,
    this.categoryKey,
    this.patientId,
    this.patientJson,
  ) {
    // Constructor'da initialize et
    setInitialValues();
  }

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

  void setInitialValues() {
    // Sadece bir kez çalışsın
    if (_isInitialized) return;

    Patient? patient;
    if (patientJson != null) {
      try {
        final Map<String, dynamic> patientMap = Patient.fromJsonString(
          patientJson!,
        );
        patient = Patient.fromMap(patientMap);
        LoggerUtil.d('Patient deserialized from JSON successfully');
      } catch (e) {
        LoggerUtil.e('Error deserializing patient JSON: $e');
      }
    }
    if (patient == null) {
      _isInitialized = true;
      return;
    }

    Map<String, dynamic>? raw;

    switch (categoryKey) {
      case 'pathology':
        raw = patient.pathology?.toMap();
        break;
      case 'oncology':
        raw = patient.oncology?.toMap();
        break;
      case 'demography':
        raw = patient.demography?.toMap();
        break;
      case 'comorbidity':
        raw = patient.comorbidity?.toMap();
        break;
      case 'biochemistry':
        raw = patient.biochemistry?.toMap();
        break;
      case 'radiology':
        raw = patient.radiology?.toMap();
        break;
      case 'pet':
        raw = patient.pet?.toMap();
        break;
      default:
        raw = {};
    }

    if (raw != null) {
      try {
        selectedValues = {};
        final configs = dropdownConfigs;

        if (configs != null) {
          raw.forEach((key, value) {
            if (value == null) {
              selectedValues[key] = null;
              return;
            }

            // Bu field için enum listesini bul
            final config = configs.firstWhere(
              (c) => c['key'] == key,
              orElse: () => <String, dynamic>{},
            );

            if (config.isNotEmpty && value is String) {
              final enumValues = config['values'] as List<Enum>;
              // String değeri Enum'a dönüştür
              try {
                final enumValue = enumValues.firstWhere((e) => e.name == value);
                selectedValues[key] = enumValue;
                LoggerUtil.d('Converted $key: $value -> ${enumValue.name}');
              } catch (e) {
                LoggerUtil.e('Could not find enum value for $key: $value');
                // İlk enum değerini varsayılan olarak kullan
                selectedValues[key] = enumValues.first;
              }
            } else {
              selectedValues[key] = value;
            }
          });
        } else {
          selectedValues = Map<String, dynamic>.from(raw);
        }

        LoggerUtil.d('Initial values set for $categoryKey: $selectedValues');
      } catch (e) {
        LoggerUtil.e('Error converting raw data to Map<String, dynamic>: $e');
      }
    } else {
      LoggerUtil.d('No initial values found for $categoryKey');
    }

    _isInitialized = true;
    notifyListeners();
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
        String? navigationFrom = NavigationService.instance
            .getPreviousRouteName();
        if (navigationFrom == '/patient-view-data') {
          NavigationService.instance.goBack();
          NavigationService.instance.goBack();
        } else {
          NavigationService.instance.goBack();
        }
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
