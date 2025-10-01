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
  final int _limit = 3; // Back to 3 patients per page
  final Set<String> _loadedPatientIds =
      {}; // Track loaded patients to avoid duplicates
  int _currentPage = 0; // Use page-based pagination as fallback

  Future<void> fetchPatients([bool forceRefresh = false]) async {
    if (_isLoading || (!_hasMore && !forceRefresh)) return;
    _isLoading = true;
    notifyListeners();

    try {
      LoggerUtil.d(
        'Starting fetchPatients - forceRefresh: $forceRefresh, page: $_currentPage, _lastDocument: $_lastDocument',
      );

      final newPatients = await repository.getPatientsPaginated(
        _limit,
        forceRefresh ? null : _lastDocument,
      );

      LoggerUtil.d('Repository returned ${newPatients.length} patients');

      if (forceRefresh) {
        _patients.clear();
        _lastDocument = null;
        _hasMore = true;
        _currentPage = 0;
        _loadedPatientIds.clear();
      }

      // Log patient details for debugging
      for (int i = 0; i < newPatients.length; i++) {
        LoggerUtil.d(
          'Patient $i: docId=${newPatients[i].docId}, name=${newPatients[i].firstName}',
        );
      }

      // TEMPORARY: Skip duplicate filtering to test repository pagination
      if (_currentPage == 0) {
        // First page: add all patients
        for (final patient in newPatients) {
          if (patient.docId != null) {
            _loadedPatientIds.add(patient.docId!);
          }
        }
        _patients.addAll(newPatients);
        LoggerUtil.d('First page - added all ${newPatients.length} patients');
      } else {
        // Subsequent pages: check if repository is working correctly
        final firstPatientId = newPatients.isNotEmpty
            ? newPatients.first.docId
            : 'none';
        LoggerUtil.d('Subsequent page - first patient ID: $firstPatientId');

        if (newPatients.isNotEmpty &&
            _loadedPatientIds.contains(firstPatientId)) {
          LoggerUtil.e(
            'REPOSITORY ISSUE: Same patients returned on page $_currentPage',
          );
          _hasMore = false;
        } else {
          // Different patients, add them
          for (final patient in newPatients) {
            if (patient.docId != null) {
              _loadedPatientIds.add(patient.docId!);
            }
          }
          _patients.addAll(newPatients);
          LoggerUtil.d('Added ${newPatients.length} new patients');
        }
      }

      // Update _lastDocument from repository
      _lastDocument = repository.lastDocument;
      LoggerUtil.d('Updated _lastDocument to: ${_lastDocument?.id}');

      _currentPage++;
      LoggerUtil.d('Total patients in list now: ${_patients.length}');

      // Simple pagination logic
      if (newPatients.length < _limit) {
        _hasMore = false;
        LoggerUtil.d(
          'No more patients available - received ${newPatients.length} < $_limit',
        );
      }
    } catch (e) {
      LoggerUtil.e('Error fetching patients: $e');
    } finally {
      LoggerUtil.d(
        'Fetching patients completed. Total patients: ${_patients.length}, hasMore: $_hasMore',
      );
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
    _currentPage = 0;
    _loadedPatientIds.clear();
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

  Future<ResponseMessage> updatePatientCategory(
    String docId,
    String categoryKey,
    Map<String, dynamic> categoryData,
  ) async {
    return await repository.updatePatientCategory(
      docId,
      categoryKey,
      categoryData,
    );
  }

  /// Belirli bir docID'ye sahip hastayı getirir.
  Future<Patient?> getPatientAllDataById(String docId) async {
    LoggerUtil.d('Fetching view_model all with ID: $docId');
    final patient = await repository.getPatientAllDataById(docId);

    LoggerUtil.d('ViewModel received patient: ${patient != null}');
    LoggerUtil.d('ViewModel patient pathology: ${patient?.pathology}');
    LoggerUtil.d('ViewModel patient comorbidity: ${patient?.comorbidity}');

    return patient;
  }

  Future<Patient?> getPatientById(String docId) async {
    LoggerUtil.d('Fetching view_model mapped with ID: $docId');
    return await repository.getPatientById(docId);
  }
}
