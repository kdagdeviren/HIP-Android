import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import '../models/patient_model.dart';

class PatientRemoteDataSource {
  final CollectionReference _patientsCollection = FirebaseFirestore.instance
      .collection('patients');

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

  Future<Patient?> getPatientById(String docId) async {
    try {
      final doc = await _patientsCollection.doc(docId).get();
      if (doc.exists) {
        return _mapDocumentToPatient(doc);
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

  Future<List<Patient>> getPatientsPaginated(
    int limit, [
    DocumentSnapshot? startAfter,
  ]) async {
    try {
      Query query = _patientsCollection.limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      final snapshot = await query.get();
      return _mapDocumentsToPatients(snapshot.docs);
    } catch (e) {
      LoggerUtil.e('Hastalar paginated getirilirken hata: $e');
      return [];
    }
  }

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
