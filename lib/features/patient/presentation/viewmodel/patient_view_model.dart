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

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  DocumentSnapshot? _lastDocument;
  final int _limit = 10;

  Future<void> fetchPatients() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final docs = await repository.getPatientsPaginated(_limit, _lastDocument);
      final newPatients = docs
          .map((doc) {
            try {
              return Patient.fromMapBasic(
                doc.data() as Map<String, dynamic>,
              ).copyWith(docId: doc.id);
            } catch (e) {
              LoggerUtil.e('Error mapping patient doc ${doc.id}: $e');
              return null;
            }
          })
          .where((p) => p != null)
          .cast<Patient>()
          .toList();

      _patients.addAll(newPatients);
      if (docs.length < _limit) {
        _hasMore = false;
      }
      if (docs.isNotEmpty) {
        _lastDocument = docs.last;
      }
    } catch (e) {
      LoggerUtil.e('Error fetching patients: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
