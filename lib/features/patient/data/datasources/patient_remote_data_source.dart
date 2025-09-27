import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_model.dart';

class PatientRemoteDataSource {
  final CollectionReference _patientsCollection = FirebaseFirestore.instance
      .collection('patients');

  Future<void> addPatient(Patient patient) async {
    await _patientsCollection.doc(patient.id).set(patient.toMap());
  }

  Future<void> updatePatient(Patient patient) async {
    await _patientsCollection.doc(patient.id).update(patient.toMap());
  }

  Future<void> deletePatient(String id) async {
    await _patientsCollection.doc(id).delete();
  }

  Stream<List<Patient>> getPatients() {
    return _patientsCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Patient.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }
}
