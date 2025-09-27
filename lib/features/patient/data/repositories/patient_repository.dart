import '../models/patient_model.dart';
import '../datasources/patient_remote_data_source.dart';

class PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  PatientRepository(this.remoteDataSource);

  Future<void> addPatient(Patient patient) =>
      remoteDataSource.addPatient(patient);
  Future<void> updatePatient(Patient patient) =>
      remoteDataSource.updatePatient(patient);
  Future<void> deletePatient(String id) => remoteDataSource.deletePatient(id);
  Stream<List<Patient>> getPatients() => remoteDataSource.getPatients();
}
