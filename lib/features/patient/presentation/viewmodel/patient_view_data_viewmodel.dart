import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/enum_display_util.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/categories_card_data.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';

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
    LoggerUtil.d('ViewData _patient hashCode: ${_patient.hashCode}');

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
        displayValue = "Veri Yok-0";
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

  /// Tüm kategorilerin verilerinin doldurulup doldurulmadığını kontrol eder
  bool areAllCategoriesCompleted() {
    if (_patient?.addedCategories == null) return false;
    return _patient!.addedCategories!.toMap().values.every(
      (element) => element == true,
    );
  }

  /// XLSX export işlemini gerçekleştirir
  Future<ExportResult> exportToXlsx() async {
    if (_patient == null) {
      return ExportResult(success: false, message: 'Hasta bilgisi bulunamadı');
    }

    if (!areAllCategoriesCompleted()) {
      return ExportResult(
        success: false,
        message: 'Tüm kategoriler doldurulmalıdır',
      );
    }

    try {
      // XLSX dosyası oluştur
      var excel = Excel.createExcel();
      var sheet = excel['Sheet1'];

      // Başlık satırı
      sheet.cell(CellIndex.indexByString('A1')).value = 'Değişken';
      sheet.cell(CellIndex.indexByString('B1')).value = 'Değer';

      int rowIndex = 2; // Başlıktan sonra başla (Excel'de 1-indexed)

      // Her kategori için verileri ekle
      final allCardData = CategoryCardData.getAllCardCategories();
      for (var cardData in allCardData) {
        final categoryData = getCategoryData(cardData.id);
        if (categoryData != null && categoryData.isNotEmpty) {
          // Get fieldConfigs for index mapping
          List<Map<String, dynamic>>? fieldConfigs;
          switch (cardData.id) {
            case 'pathology':
              fieldConfigs = Pathology.getDropdownConfigs();
              break;
            case 'oncology':
              fieldConfigs = Oncology.getDropdownConfigs();
              break;
            case 'demography':
              fieldConfigs = Demography.getDropdownConfigs();
              break;
            case 'comorbidity':
              fieldConfigs = Comorbidity.getDropdownConfigs();
              break;
            case 'biochemistry':
              fieldConfigs = Biochemistry.getDropdownConfigs();
              break;
            case 'radiology':
              fieldConfigs = Radiology.getDropdownConfigs();
              break;
            default:
              fieldConfigs = null;
          }

          // Create label to index map
          Map<String, int> labelToIndex = {};
          if (fieldConfigs != null) {
            for (var config in fieldConfigs) {
              labelToIndex[config['label'] as String] =
                  (config['index'] as int?) ?? 0;
            }
          }

          categoryData.forEach((key, value) {
            int index = labelToIndex[key] ?? 0; // Default to 0 if not found
            List<String> parts = value.split('-');
            String code = parts.length > 1 ? parts[1] : value;

            // Yeni satır ekle
            sheet.cell(CellIndex.indexByString('A$rowIndex')).value = 'i$index';
            sheet.cell(CellIndex.indexByString('B$rowIndex')).value = code;
            //sheet.cell(CellIndex.indexByString('C$rowIndex')).value = value;
            rowIndex++;
          });
        }
      }

      // XLSX dosyasını byte array olarak al
      var bytes = excel.encode();

      // Dosyayı kaydet ve paylaş
      final directory = await getApplicationDocumentsDirectory();
      final dateFormat = DateFormat('dd-MM-yyyy');
      final formattedDate = dateFormat.format(DateTime.now());
      final path =
          '${directory.path}/hasta_${_patient!.protocolNo}_$formattedDate.xlsx';
      final file = File(path);

      // Dosyayı kaydet
      await file.writeAsBytes(bytes!);

      // Dosyayı paylaş
      await Share.shareXFiles(
        [XFile(path)],
        subject:
            'Hasta Verileri - ${_patient!.firstName} ${_patient!.lastName}',
      );

      return ExportResult(
        success: true,
        message: 'XLSX dosyası oluşturuldu ve paylaşıldı',
      );
    } catch (e) {
      LoggerUtil.e('XLSX export error: $e');
      return ExportResult(success: false, message: 'Hata: ${e.toString()}');
    }
  }
}

/// CSV export sonuç modeli
class ExportResult {
  final bool success;
  final String message;

  ExportResult({required this.success, required this.message});
}
