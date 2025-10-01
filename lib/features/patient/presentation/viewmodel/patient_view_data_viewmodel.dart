import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/enum_display_util.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientViewDataViewmodel extends ChangeNotifier {
  final String? patientId;
  final PatientViewModel? patientViewModel;
  Patient? _patient;
  bool _isLoading = false;

  PatientViewDataViewmodel({this.patientId, this.patientViewModel}) {
    if (patientId != null) {
      fetchPatient();
    }
  }

  bool get isLoading => _isLoading;
  Patient? get patient => _patient;

  Future<void> fetchPatient() async {
    _isLoading = true;
    notifyListeners();

    _patient = await patientViewModel!.getPatientAllDataById(patientId!);

    LoggerUtil.d('ViewData received patient: ${_patient != null}');
    LoggerUtil.d('ViewData _patient hashCode: ${_patient.hashCode}'); // ← EKLE
    LoggerUtil.d('ViewData patient pathology: ${_patient?.pathology}');
    LoggerUtil.d('ViewData patient comorbidity: ${_patient?.comorbidity}');

    _isLoading = false;
    notifyListeners();
  }

  Map<String, String>? getCategoryData(String categoryKey) {
    if (_patient == null) return null;

    Map<String, dynamic>? raw;
    List<Map<String, dynamic>>? fieldConfigs;

    switch (categoryKey) {
      case 'pathology':
        raw = _patient!.pathology?.toMap();
        fieldConfigs = Pathology.getDropdownConfigs();
        break;
      case 'oncology':
        raw = _patient!.oncology?.toMap();
        fieldConfigs = Oncology.getDropdownConfigs();
        break;
      case 'demography':
        raw = _patient!.demography?.toMap();
        fieldConfigs = Demography.getDropdownConfigs();
        break;
      case 'comorbidity':
        raw = _patient!.comorbidity?.toMap();
        fieldConfigs = Comorbidity.getDropdownConfigs();
        break;
      case 'biochemistry':
        raw = _patient!.biochemistry?.toMap();
        fieldConfigs = Biochemistry.getDropdownConfigs();
        break;
      case 'radiology':
        raw = _patient!.radiology?.toMap();
        fieldConfigs = Radiology.getDropdownConfigs();
        break;
      case 'pet':
        raw = _patient!.pet?.toMap();
        fieldConfigs = PET.getDropdownConfigs();
        break;
      default:
        return null;
    }

    if (raw == null) return null;

    // Create label map
    Map<String, String> keyToLabel = {};
    for (var config in fieldConfigs) {
      keyToLabel[config['key'] as String] = config['label'] as String;
    }

    // Convert to display format
    return raw.map((key, value) {
      String displayKey = keyToLabel[key] ?? key;
      String displayValue;

      if (value == null) {
        displayValue = "Belirtilmemiş";
      } else if (value is String) {
        // EnumDisplayUtil ile displayText'i al
        displayValue = EnumDisplayUtil.getDisplayTextByFieldName(
          key,
          value,
          categoryKey,
        );
      } else {
        displayValue = value.toString();
      }

      return MapEntry(displayKey, displayValue);
    });
  }
}
