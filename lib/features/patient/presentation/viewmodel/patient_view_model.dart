import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository repository;

  PatientViewModel(this.repository);

  Stream<List<Patient>> get patients => repository.getPatients();

  Future<ResponseMessage> addPatient(Patient patient) async {
    return await repository.addPatient(patient);
  }

  Future<ResponseMessage> updatePatient(String docId, Patient patient) async {
    return await repository.updatePatient(docId, patient);
  }

  Future<ResponseMessage> deletePatient(String id) async {
    return await repository.deletePatient(id);
  }

  /// Belirli bir docID'ye sahip hastayı getirir.
  Future<Patient?> getPatientById(String docId) async {
    return await repository.getPatientById(docId);
  }
}
