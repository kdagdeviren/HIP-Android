import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';

import '../models/patient_model.dart';
import '../datasources/patient_remote_data_source.dart';

class PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepository(this.remoteDataSource);

  Future<ResponseMessage> addPatient(Patient patient) =>
      remoteDataSource.addPatient(patient);
  Future<ResponseMessage> updatePatient(String docId, Patient patient) =>
      remoteDataSource.updatePatient(docId, patient);
  Future<ResponseMessage> deletePatient(String id) =>
      remoteDataSource.deletePatient(id);
  Stream<List<Patient>> getPatients() => remoteDataSource.getPatients();
  Future<List<QueryDocumentSnapshot>> getPatientsPaginated(
    int limit, [
    DocumentSnapshot? startAfter,
  ]) => remoteDataSource.getPatientsPaginated(limit, startAfter);
  Future<Patient?> getPatientById(String docId) =>
      remoteDataSource.getPatientById(docId);
}
