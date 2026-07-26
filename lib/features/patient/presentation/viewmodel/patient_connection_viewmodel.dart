import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_connection_model.dart';
import 'package:flutter_medical_data_app/features/patient/data/repositories/patient_connection_repository.dart';

class PatientConnectionViewModel extends ChangeNotifier {
  final PatientConnectionRepository repository;

  PatientConnectionViewModel(this.repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _connectedPatientIds = [];
  List<String> get connectedPatientIds => _connectedPatientIds;

  List<PatientConnection> _connections = [];
  List<PatientConnection> get connections => _connections;

  /// Kullanıcının bağlı olduğu hasta ID'lerini yükler
  Future<void> loadConnectedPatientIds(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _connectedPatientIds = await repository.getPatientIdsByUserId(userId);
      LoggerUtil.d('Loaded ${_connectedPatientIds.length} connected patients');
    } catch (e) {
      LoggerUtil.e('Error loading connected patient IDs: $e');
      _connectedPatientIds = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Yeni bir hasta-kullanıcı bağlantısı oluşturur
  Future<ResponseMessage> connectPatient({
    required String patientId,
    required String userId,
    required ConnectionRole role,
  }) async {
    try {
      final connection = PatientConnection(
        patientId: patientId,
        userId: userId,
        role: role,
      );

      final response = await repository.createConnection(connection);

      if (response.status) {
        // Başarılı olursa listeye ekle
        if (!_connectedPatientIds.contains(patientId)) {
          _connectedPatientIds.add(patientId);
          notifyListeners();
        }
      }

      return response;
    } catch (e) {
      LoggerUtil.e('Error connecting patient: $e');
      return ResponseMessage(
        status: false,
        message: L10n.current.patient_connection_createFailed(e.toString()),
      );
    }
  }

  /// Bir bağlantıyı siler
  Future<ResponseMessage> disconnectPatient(
    String connectionId,
    String patientId,
  ) async {
    try {
      final response = await repository.deleteConnection(connectionId);

      if (response.status) {
        _connectedPatientIds.remove(patientId);
        _connections.removeWhere((c) => c.docId == connectionId);
        notifyListeners();
      }

      return response;
    } catch (e) {
      LoggerUtil.e('Error disconnecting patient: $e');
      return ResponseMessage(
        status: false,
        message: L10n.current.patient_connection_deleteFailed(e.toString()),
      );
    }
  }

  /// Bir hastanın tüm bağlantılarını yükler
  Future<void> loadConnectionsByPatient(String patientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _connections = await repository.getConnectionsByPatientId(patientId);
      LoggerUtil.d('Loaded ${_connections.length} connections for patient');
    } catch (e) {
      LoggerUtil.e('Error loading connections: $e');
      _connections = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Kullanıcının bir hastaya bağlı olup olmadığını kontrol eder
  bool isConnectedToPatient(String patientId) {
    return _connectedPatientIds.contains(patientId);
  }

  /// Kullanıcının toplam bağlı hasta sayısını döner
  Future<int> getConnectionCount(String userId) async {
    try {
      return await repository.getConnectionCountByUserId(userId);
    } catch (e) {
      LoggerUtil.e('Error getting connection count: $e');
      return 0;
    }
  }
}
