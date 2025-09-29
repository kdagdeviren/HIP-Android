import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientAddViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  PatientAddViewmodel(this.patientViewModel);

  /// Validates patient form data
  String? validatePatientData(String name, String surname, String protocolNo) {
    final nameError = ValidationUtil.getNameErrorMessage(name);
    if (nameError != null) return "Ad: ${nameError.toLowerCase()}";

    final surnameError = ValidationUtil.getNameErrorMessage(surname);
    if (surnameError != null) return "Soyad: ${surnameError.toLowerCase()}";

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
        mainDoctorId: FirebaseAuth.instance.currentUser!.uid,
      );

      LoggerUtil.i(
        "Adding patient with mainDoctorId: ${newPatient.mainDoctorId}",
      );

      ResponseMessage response = await patientViewModel.addPatient(newPatient);
      if (response.status) {
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
    final response = await addPatient(
      name: name,
      surname: surname,
      protocolNo: protocolNo,
    );

    if (response.status) {
      _navigateToPatientList();
      _showSuccessMessage(context);
    } else {
      _showErrorMessage(context, response.message);
    }
  }

  void _navigateToPatientList() {
    NavigationService.instance.goBack();
    NavigationService.instance.navigateTo('/patient-all-list');
  }

  void _showSuccessMessage(BuildContext context) {
    ErrorHandler.showSuccessSnackBar(context, "Hasta başarıyla eklendi.");
  }

  void _showErrorMessage(BuildContext context, String message) {
    ErrorHandler.showErrorSnackBar(context, message);
  }
}
