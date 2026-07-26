import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
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

  /// Set when a fetch fails, so the list can say what went wrong instead of
  /// spinning forever on an empty page.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  DocumentSnapshot? _lastDocument;
  final int _limit = 3; // Back to 3 patients per page

  Future<void> fetchPatients([bool forceRefresh = false]) async {
    if (_isLoading || (!_hasMore && !forceRefresh)) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        LoggerUtil.e('User not authenticated');
        // Without this the list keeps hasMore == true and renders an endless
        // spinner over an empty list.
        _hasMore = false;
        _errorMessage = 'Oturum bulunamadı. Lütfen tekrar giriş yapın.';
        return;
      }

      if (forceRefresh) {
        _patients.clear();
        _lastDocument = null;
        _hasMore = true;
      }

      // Yetki dizisi üzerinden tek sorgu. Eskiden önce bağlantı ID'leri
      // çekilip hastalar 10'arlı `whereIn` batch'leriyle alınıyordu; imleç
      // batch'ler arasında paylaşıldığı için sayfalama da hatalıydı.
      final page = await repository.getPatientsForUser(
        currentUserId,
        _limit,
        _lastDocument,
      );

      _patients.addAll(page.patients);
      _lastDocument = page.cursor;
      _hasMore = page.patients.length == _limit;

      LoggerUtil.d('Fetched ${page.patients.length} new patients');
    } catch (e) {
      LoggerUtil.e('Error fetching patients: $e');
      _hasMore = false;
      _errorMessage = ErrorHandler.handleError(e, 'Fetch Patients');
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
