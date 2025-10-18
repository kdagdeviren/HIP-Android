import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import '../../data/models/patient_model.dart';
import '../../data/repositories/patient_repository.dart';
import '../../data/repositories/patient_connection_repository.dart';

class PatientViewModel extends ChangeNotifier {
  final PatientRepository repository;
  final PatientConnectionRepository connectionRepository;

  PatientViewModel(this.repository, this.connectionRepository) {
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
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        LoggerUtil.e('User not authenticated');
        _isLoading = false;
        notifyListeners();
        return;
      }

      LoggerUtil.d(
        'Starting fetchPatients - forceRefresh: $forceRefresh, page: $_currentPage',
      );

      // 1. Önce kullanıcının bağlı olduğu hasta ID'lerini al
      final connectedPatientIds = await connectionRepository
          .getPatientIdsByUserId(currentUserId);

      if (connectedPatientIds.isEmpty) {
        LoggerUtil.d('No connected patients found for user');
        _patients = [];
        _hasMore = false;
        _isLoading = false;
        notifyListeners();
        return;
      }

      LoggerUtil.d('User has ${connectedPatientIds.length} connected patients');

      if (forceRefresh) {
        _patients.clear();
        _lastDocument = null;
        _hasMore = true;
        _currentPage = 0;
        _loadedPatientIds.clear();
      }

      // 2. Bu ID'lere sahip hastaları getir (pagination ile)
      // Firestore'da "in" sorgusu max 10 item destekler, bu yüzden batch'lere ayırıyoruz
      final batchSize = 10;
      List<Patient> newPatients = [];

      for (int i = 0; i < connectedPatientIds.length; i += batchSize) {
        final batch = connectedPatientIds.skip(i).take(batchSize).toList();

        Query query = FirebaseFirestore.instance
            .collection('patients')
            .where(FieldPath.documentId, whereIn: batch)
            .orderBy('createdAt', descending: true)
            .limit(_limit);

        if (_lastDocument != null && !forceRefresh) {
          query = query.startAfterDocument(_lastDocument!);
        }

        final snapshot = await query.get();

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final patient = Patient.fromMapBasic(data).copyWith(docId: doc.id);

          if (!_loadedPatientIds.contains(patient.docId)) {
            newPatients.add(patient);
            if (patient.docId != null) {
              _loadedPatientIds.add(patient.docId!);
            }
          }
        }

        if (snapshot.docs.isNotEmpty) {
          _lastDocument = snapshot.docs.last;
        }

        // İlk batch'ten sonra limit'e ulaştıysak dur
        if (newPatients.length >= _limit) break;
      }

      LoggerUtil.d('Fetched ${newPatients.length} new patients');

      _patients.addAll(newPatients);
      _currentPage++;

      if (newPatients.length < _limit) {
        _hasMore = false;
        LoggerUtil.d('No more patients available');
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
