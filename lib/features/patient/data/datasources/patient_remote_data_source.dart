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
      await docRef.set(patient.toMap());
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
      await _patientsCollection.doc(docId).update(patient.toMap());
      return ResponseMessage(
        status: true,
        message: 'Hasta başarıyla güncellendi',
      );
    } catch (e) {
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
        return Patient.fromMap(doc.data() as Map<String, dynamic>);
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
        (snapshot) => snapshot.docs
            .map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      LoggerUtil.e('Hastalar getirilirken hata oluştu: $e');
      return Stream.value([]);
    }
  }
}
