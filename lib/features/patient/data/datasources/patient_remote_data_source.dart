import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import '../models/patient_model.dart';

class PatientRemoteDataSource {
  final CollectionReference _patientsCollection = FirebaseFirestore.instance
      .collection('patients');

  Future<ResponseMessage> updatePatientCategory(
    String docId,
    String categoryKey,
    Map<String, dynamic> categoryData,
  ) async {
    try {
      await _patientsCollection.doc(docId).update({
        categoryKey: categoryData,
        'addedCategories.$categoryKey': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ResponseMessage(
        status: true,
        message: 'Kategori başarıyla güncellendi',
      );
    } catch (e) {
      LoggerUtil.e('Error updating patient category: $e');
      return ResponseMessage(
        status: false,
        message: 'Kategori güncellenirken hata oluştu: $e',
      );
    }
  }

  Future<ResponseMessage> addPatient(Patient patient) async {
    try {
      final docRef = _patientsCollection.doc();
      final patientData = patient.toMap();
      // Use server timestamp for createdAt and updatedAt
      patientData['createdAt'] = FieldValue.serverTimestamp();
      patientData['updatedAt'] = FieldValue.serverTimestamp();

      await docRef.set(patientData);
      return ResponseMessage(
        status: true,
        message: 'Hasta başarıyla eklendi',
        docId: docRef.id,
      );
    } catch (e) {
      return ResponseMessage(
        status: false,
        message: 'Hasta eklenirken hata oluştu: $e',
      );
    }
  }

  Future<ResponseMessage> updatePatient(String docId, Patient patient) async {
    try {
      final patientData = patient.toMap();
      // Update timestamp on modification
      patientData['updatedAt'] = FieldValue.serverTimestamp();

      await _patientsCollection.doc(docId).update(patientData);
      return ResponseMessage(
        status: true,
        message: 'Hasta başarıyla güncellendi',
      );
    } catch (e) {
      LoggerUtil.e('Hasta güncellenirken: $e');
      return ResponseMessage(
        status: false,
        message: 'Hasta güncellenirken hata oluştu: $e',
      );
    }
  }

  Future<ResponseMessage> deletePatient(String id) async {
    try {
      await _patientsCollection.doc(id).delete();
      return ResponseMessage(status: true, message: 'Hasta başarıyla silindi');
    } catch (e) {
      return ResponseMessage(
        status: false,
        message: 'Hasta silinirken hata oluştu: $e',
      );
    }
  }

  Future<Patient?> getPatientById(
    String docId, {
    bool forceRefresh = false,
  }) async {
    LoggerUtil.d('Fetching remote_data mapped patient with ID: $docId');
    try {
      GetOptions options;

      if (forceRefresh) {
        // Force server'dan al
        options = const GetOptions(source: Source.server);
      } else {
        // Önce cache'e bak, yoksa server'dan al
        options = const GetOptions(source: Source.serverAndCache);
      }

      final doc = await _patientsCollection.doc(docId).get(options);

      if (doc.exists) {
        return _mapDocumentToPatient(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Patient?> getPatientAllDataById(
    String docId, {
    bool forceRefresh = false,
  }) async {
    try {
      GetOptions options;

      if (forceRefresh) {
        // Force server'dan al
        options = const GetOptions(source: Source.server);
      } else {
        // Önce cache'e bak, yoksa server'dan al
        options = const GetOptions(source: Source.serverAndCache);
      }

      final doc = await _patientsCollection.doc(docId).get(options);

      if (doc.exists) {
        return Patient.fromMap(
          doc.data() as Map<String, dynamic>,
        ).copyWith(docId: doc.id);
      }
      return null;
    } catch (e) {
      LoggerUtil.e('Hastayı getirirken hata oluştu: $e');
      return null;
    }
  }

  Stream<List<Patient>> getPatients() {
    try {
      return _patientsCollection.snapshots().map(
        (snapshot) => _mapDocumentsToPatients(snapshot.docs),
      );
    } catch (e) {
      LoggerUtil.e('Hastalar getirilirken hata oluştu: $e');
      return Stream.value([]);
    }
  }

  DocumentSnapshot? _lastDocument;

  Future<List<Patient>> getPatientsPaginated(
    int limit, [
    DocumentSnapshot? startAfter,
  ]) async {
    try {
      Query query = _patientsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      final snapshot = await query.get();

      // Store the last document for next pagination
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        LoggerUtil.d('Stored last document: ${_lastDocument?.id}');
      }

      return _mapDocumentsToPatients(snapshot.docs);
    } catch (e) {
      LoggerUtil.e('Hastalar paginated getirilirken hata: $e');
      return [];
    }
  }

  // Add a getter to access the last document
  DocumentSnapshot? get lastDocument => _lastDocument;

  /// Maps a single document to Patient object
  Patient? _mapDocumentToPatient(DocumentSnapshot doc) {
    try {
      return Patient.fromMapBasic(
        doc.data() as Map<String, dynamic>,
      ).copyWith(docId: doc.id);
    } catch (e) {
      LoggerUtil.e('Error mapping patient doc ${doc.id}: $e');
      return null;
    }
  }

  /// Maps multiple documents to list of Patient objects
  List<Patient> _mapDocumentsToPatients(List<QueryDocumentSnapshot> docs) {
    return docs
        .map((doc) => _mapDocumentToPatient(doc))
        .where((patient) => patient != null)
        .cast<Patient>()
        .toList();
  }
}
