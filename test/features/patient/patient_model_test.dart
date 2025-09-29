import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/patient_model.dart';

void main() {
  group('Patient Model Tests', () {
    test('should create Patient from map with Timestamp', () {
      // Arrange
      final now = DateTime.now();
      final testMap = {
        'firstName': 'Ahmet',
        'lastName': 'Yılmaz',
        'protocolNo': 'P123456',
        'mainDoctorId': 'doctor123',
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      };

      // Act
      final patient = Patient.fromMap(testMap);

      // Assert
      expect(patient.firstName, 'Ahmet');
      expect(patient.lastName, 'Yılmaz');
      expect(patient.protocolNo, 'P123456');
      expect(patient.mainDoctorId, 'doctor123');
      expect(patient.createdAt, isNotNull);
      expect(patient.updatedAt, isNotNull);
    });

    test('should create Patient from map with ISO string dates', () {
      // Arrange
      final now = DateTime.now();
      final testMap = {
        'firstName': 'Ayşe',
        'lastName': 'Demir',
        'protocolNo': 'P789012',
        'mainDoctorId': 'doctor456',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      // Act
      final patient = Patient.fromMap(testMap);

      // Assert
      expect(patient.firstName, 'Ayşe');
      expect(patient.lastName, 'Demir');
      expect(patient.protocolNo, 'P789012');
      expect(patient.mainDoctorId, 'doctor456');
      expect(patient.createdAt, isNotNull);
      expect(patient.updatedAt, isNotNull);
    });

    test('should handle null date values gracefully', () {
      // Arrange
      final testMap = {
        'firstName': 'Test',
        'lastName': 'User',
        'protocolNo': 'P000000',
        'mainDoctorId': 'doctor000',
        'createdAt': null,
        'updatedAt': null,
      };

      // Act
      final patient = Patient.fromMap(testMap);

      // Assert
      expect(patient.firstName, 'Test');
      expect(patient.lastName, 'User');
      expect(patient.createdAt, isNull);
      expect(patient.updatedAt, isNull);
    });

    test('should handle missing fields with defaults', () {
      // Arrange
      final testMap = <String, dynamic>{};

      // Act
      final patient = Patient.fromMap(testMap);

      // Assert
      expect(patient.firstName, '');
      expect(patient.lastName, '');
      expect(patient.protocolNo, '');
      expect(patient.mainDoctorId, '');
    });

    test('toMap should create valid map structure', () {
      // Arrange
      final now = DateTime.now();
      final patient = Patient(
        firstName: 'Test',
        lastName: 'Patient',
        protocolNo: 'P123',
        mainDoctorId: 'doc123',
        createdAt: now,
        updatedAt: now,
      );

      // Act
      final map = patient.toMap();

      // Assert
      expect(map['firstName'], 'Test');
      expect(map['lastName'], 'Patient');
      expect(map['protocolNo'], 'P123');
      expect(map['mainDoctorId'], 'doc123');
      expect(map['createdAt'], now);
      expect(map['updatedAt'], now);
    });

    test('copyWith should update only specified fields', () {
      // Arrange
      final originalPatient = Patient(
        firstName: 'Original',
        lastName: 'Name',
        protocolNo: 'P001',
        mainDoctorId: 'doc001',
      );

      // Act
      final updatedPatient = originalPatient.copyWith(
        firstName: 'Updated',
        docId: 'new_doc_id',
      );

      // Assert
      expect(updatedPatient.firstName, 'Updated');
      expect(updatedPatient.lastName, 'Name'); // unchanged
      expect(updatedPatient.protocolNo, 'P001'); // unchanged
      expect(updatedPatient.docId, 'new_doc_id');
    });

    test('fromMapBasic should parse with docId and limited fields', () {
      // Arrange
      final testMap = {
        'docId': 'test_doc_123',
        'firstName': 'Basic',
        'lastName': 'Test',
        'protocolNo': 'P999',
        'mainDoctorId': 'doc999',
        'createdAt': DateTime.now().toIso8601String(),
        'pathology': {
          'someData': 'value',
        }, // should be ignored in basic parsing
      };

      // Act
      final patient = Patient.fromMapBasic(testMap);

      // Assert
      expect(patient.docId, 'test_doc_123');
      expect(patient.firstName, 'Basic');
      expect(patient.lastName, 'Test');
      expect(patient.pathology, isNull); // should be null in basic parsing
    });
  });
}
