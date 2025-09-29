import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository repository;

  PatientViewModel(this.repository) {
    fetchPatients();
  }

  // ignore: prefer_final_fields
  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  DocumentSnapshot? _lastDocument;
  final int _limit = 10;

  Future<void> fetchPatients([bool forceRefresh = false]) async {
    if (_isLoading || (!_hasMore && !forceRefresh)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPatients = await repository.getPatientsPaginated(
        _limit,
        forceRefresh ? null : _lastDocument,
      );

      if (forceRefresh) {
        _patients.clear();
        _lastDocument = null;
        _hasMore = true;
      }

      _patients.addAll(newPatients);

      if (newPatients.length < _limit) {
        _hasMore = false;
      }

      // Update last document for pagination (need to get raw docs for this)
      // Note: This is a temporary solution - ideally we'd return both patients and last doc
      if (newPatients.isNotEmpty) {
        // For now, we'll rely on createdAt for pagination ordering
        _hasMore = newPatients.length == _limit;
      }
    } catch (e) {
      LoggerUtil.e('Error fetching patients: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Reset pagination and fetch fresh data
  Future<void> refresh() async {
    await fetchPatients(true);
  }

  /// Reset pagination state
  void resetPagination() {
    _patients.clear();
    _lastDocument = null;
    _hasMore = true;
    notifyListeners();
  }

  Future<ResponseMessage> addPatient(Patient patient) async {
    final response = await repository.addPatient(patient);
    if (response.status && response.docId != null) {
      // Yeni hastayı listeye ekle
      final newPatient = patient.copyWith(docId: response.docId);
      _patients.insert(0, newPatient); // Başa ekle
      notifyListeners();
    }
    return response;
  }

  Future<ResponseMessage> updatePatient(String docId, Patient patient) async {
    final response = await repository.updatePatient(docId, patient);
    if (response.status) {
      final index = _patients.indexWhere((p) => p.docId == docId);
      if (index != -1) {
        _patients[index] = patient.copyWith(docId: docId);
        notifyListeners();
      }
    }
    return response;
  }

  Future<ResponseMessage> deletePatient(String id) async {
    final response = await repository.deletePatient(id);
    if (response.status) {
      _patients.removeWhere((p) => p.docId == id);
      notifyListeners();
    }
    return response;
  }

  /// Belirli bir docID'ye sahip hastayı getirir.
  Future<Patient?> getPatientById(String docId) async {
    return await repository.getPatientById(docId);
  }
}
