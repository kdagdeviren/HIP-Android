import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_repository.dart';

class PatientEnterDataViewModel extends ChangeNotifier {
  final PatientRepository _patientRepository = PatientRepository(
    PatientRemoteDataSource(),
  );

  Patient? _currentPatient;
  bool _isLoading = false;
  bool _isDisposed = false; // Dispose kontrolü için flag

  Patient? get currentPatient => _currentPatient;
  bool get isLoading => _isLoading;

  Future<void> loadPatientById(String patientId, BuildContext context) async {
    try {
      _isLoading = true;
      if (!_isDisposed) notifyListeners(); // Dispose kontrolü

      loading.show(context);
      _currentPatient = await _patientRepository.getPatientById(patientId);

      _isLoading = false;
      if (!_isDisposed) notifyListeners(); // Dispose kontrolü

      loading.close();
    } catch (e) {
      _isLoading = false;
      if (!_isDisposed) notifyListeners(); // Dispose kontrolü
      loading.close();

      // Hata durumunda kullanıcıyı bilgilendirin
      LoggerUtil.d('Hasta bilgileri yüklenirken hata oluştu: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Dispose edildiğini işaretle
    _currentPatient = null;
    _isLoading = false;
    super.dispose();
  }

  void clearCurrentPatient() {
    _currentPatient = null;
    if (!_isDisposed) notifyListeners(); // Dispose kontrolü
  }
}
