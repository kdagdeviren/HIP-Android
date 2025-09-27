import 'package:flutter/material.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository repository;

  PatientViewModel(this.repository);

  Stream<List<Patient>> get patients => repository.getPatients();

  Future<void> addPatient(Patient patient) async {
    await repository.addPatient(patient);
  }

  Future<void> updatePatient(Patient patient) async {
    await repository.updatePatient(patient);
  }

  Future<void> deletePatient(String id) async {
    await repository.deletePatient(id);
  }
}
