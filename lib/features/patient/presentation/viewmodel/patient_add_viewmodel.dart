import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_connection_viewmodel.dart';

class PatientAddViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  final PatientConnectionViewModel connectionViewModel;

  PatientAddViewmodel(this.patientViewModel, this.connectionViewModel);

  /// Validates patient form data
  String? validatePatientData(String name, String surname, String protocolNo) {
    final nameError = ValidationUtil.getNameErrorMessage(name);
    if (nameError != null) {
      return L10n.current.patient_add_namePrefix(nameError.toLowerCase());
    }

    final surnameError = ValidationUtil.getNameErrorMessage(surname);
    if (surnameError != null) {
      return L10n.current.auth_register_surnamePrefix(
        surnameError.toLowerCase(),
      );
    }

    final protocolError = ValidationUtil.getProtocolNumberErrorMessage(
      protocolNo,
    );
    if (protocolError != null) return protocolError;

    return null;
  }

  /// Adds a new patient
  Future<ResponseMessage> addPatient({
    required String name,
    required String surname,
    required String protocolNo,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return ResponseMessage(
          status: false,
          message: L10n.current.patient_common_sessionNotFound,
        );
      }

      // Validate input
      final validationError = validatePatientData(name, surname, protocolNo);
      if (validationError != null) {
        return ResponseMessage(status: false, message: validationError);
      }

      Patient newPatient = Patient(
        firstName: name,
        lastName: surname,
        protocolNo: protocolNo,
        createdAt: DateTime.now(),
        mainDoctorId: currentUser.uid,
      );

      LoggerUtil.i(
        "Adding patient with mainDoctorId: ${newPatient.mainDoctorId}",
      );

      // 1. Hastayı ekle
      ResponseMessage response = await patientViewModel.addPatient(newPatient);

      if (response.status && response.docId != null) {
        // 2. Kullanıcı-hasta bağlantısını oluştur (owner olarak)
        final connectionResponse = await connectionViewModel.connectPatient(
          patientId: response.docId!,
          userId: currentUser.uid,
          role: ConnectionRole.owner,
        );

        if (!connectionResponse.status) {
          LoggerUtil.e(
            'Patient created but connection failed: ${connectionResponse.message}',
          );
          // İsterseniz hastayı geri silip rollback yapabilirsiniz
        }

        LoggerUtil.i("Hasta başarıyla eklendi: ${response.message}");
      }

      return response;
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e, 'Add Patient');
      return ResponseMessage(status: false, message: errorMessage);
    }
  }

  Future<void> handleAddPatient(
    BuildContext context, {
    required String name,
    required String surname,
    required String protocolNo,
  }) async {
    // Loading göster
    loading.show(context);

    try {
      final response = await addPatient(
        name: name,
        surname: surname,
        protocolNo: protocolNo,
      );

      if (response.status) {
        _navigateToPatientList();
        if (context.mounted) {
          _showSuccessMessage(context);
        }
      } else {
        if (context.mounted) {
          _showErrorMessage(context, response.message);
        }
      }
    } finally {
      // Loading kapat
      loading.close();
    }
  }

  void _navigateToPatientList() {
    NavigationService.instance.goBack();
    NavigationService.instance.navigateTo('/patient-all-list');
  }

  void _showSuccessMessage(BuildContext context) {
    ErrorHandler.showSuccessSnackBar(
      context,
      L10n.current.patient_add_addSuccess,
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ErrorHandler.showErrorSnackBar(context, message);
  }
}
