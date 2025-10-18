import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/datasources/patient_connection_remote_data_source.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';

class PatientConnectionRepository {
  final PatientConnectionRemoteDataSource remoteDataSource;

  PatientConnectionRepository(this.remoteDataSource);

  Future<ResponseMessage> createConnection(PatientConnection connection) =>
      remoteDataSource.createConnection(connection);

  Future<List<String>> getPatientIdsByUserId(String userId) =>
      remoteDataSource.getPatientIdsByUserId(userId);

  Future<int> getConnectionCountByUserId(String userId) =>
      remoteDataSource.getConnectionCountByUserId(userId);

  Future<ResponseMessage> deleteConnection(String connectionId) =>
      remoteDataSource.deleteConnection(connectionId);

  Future<ResponseMessage> updateConnectionRole(
    String connectionId,
    ConnectionRole newRole,
  ) => remoteDataSource.updateConnectionRole(connectionId, newRole);

  Future<PatientConnection?> getConnection(String patientId, String userId) =>
      remoteDataSource.getConnection(patientId, userId);

  Future<List<PatientConnection>> getConnectionsByPatientId(String patientId) =>
      remoteDataSource.getConnectionsByPatientId(patientId);
}
