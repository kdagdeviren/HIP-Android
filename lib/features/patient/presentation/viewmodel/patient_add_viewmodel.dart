import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';
import 'package:flutter_medical_data_app/features/patient/presentation/viewmodel/patient_view_model.dart';

class PatientAddViewmodel extends ChangeNotifier {
  final PatientViewModel patientViewModel;
  PatientAddViewmodel(this.patientViewModel);

  Future<ResponseMessage> addPatient({
    required String name,
    required String surname,
    required String protocolNo,
    required BuildContext context,
  }) async {
    try {
      if (name.isEmpty || surname.isEmpty || protocolNo.isEmpty) {
        PopupService().showError(
          context,
          "Hata",
          "Lütfen tüm alanları doldurun.",
        );

        return ResponseMessage(
          status: false,
          message: "Lütfen tüm alanları doldurun.",
        );
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
      if (!response.status) {
        PopupService().showError(context, "Hata", response.message);
        return response;
      } else {
        LoggerUtil.i("Hasta başarıyla eklendi: ${response.message}");

        NavigationService.instance.goBack();
        NavigationService.instance.navigateTo('/patient-all-list');
        PopupService().showSuccess(
          context,
          "Başarılı",
          "Hasta başarıyla eklendi.",
        );
      }

      return ResponseMessage(status: true, message: "Hasta başarıyla eklendi.");
    } catch (e) {
      PopupService().showError(
        context,
        "Hata",
        "Hasta eklenirken bir hata oluştu: $e",
      );
      return ResponseMessage(
        status: false,
        message: "Hasta eklenirken bir hata oluştu: $e",
      );
    }
  }
}
