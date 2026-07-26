import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/features/patient/data/models/added_categories.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/pathology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/oncology.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/demography.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/comorbidity.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/biochemistry.dart';
import 'package:flutter_medical_data_app/features/patient/domain/entities/categories/radiology.dart';

class Patient {
  final String? docId;
  final String firstName;
  final String lastName;
  final String protocolNo;
  final String mainDoctorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Pathology? pathology;
  final Oncology? oncology;
  final Demography? demography;
  final Comorbidity? comorbidity;
  final Biochemistry? biochemistry;
  final Radiology? radiology;
  final AddedCategories? addedCategories;

  /// UIDs allowed to read and write this patient.
  ///
  /// Denormalized from `patient_connections` so security rules can authorize a
  /// request from the patient document alone — rules cannot run queries. The
  /// connection documents remain the source of truth for roles; this list is a
  /// derived index maintained by [PatientConnectionRemoteDataSource].
  final List<String> authorizedUserIds;

  Patient({
    this.docId,
    required this.firstName,
    required this.lastName,
    required this.protocolNo,
    required this.mainDoctorId,
    this.createdAt,
    this.updatedAt,
    this.pathology,
    this.oncology,
    this.demography,
    this.comorbidity,
    this.biochemistry,
    this.radiology,
    this.addedCategories,
    this.authorizedUserIds = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'protocolNo': protocolNo,
      'mainDoctorId': mainDoctorId,
      'pathology': pathology?.toMap(),
      'oncology': oncology?.toMap(),
      'demography': demography?.toMap(),
      'comorbidity': comorbidity?.toMap(),
      'biochemistry': biochemistry?.toMap(),
      'radiology': radiology?.toMap(),
      'addedCategories': addedCategories?.toMap(),
      // Note: authorizedUserIds is deliberately omitted. It is written only by
      // the connection flow via arrayUnion/arrayRemove, so a stale in-memory
      // copy can never overwrite the authoritative list.
      // Note: createdAt/updatedAt will be handled at datasource level with FieldValue.serverTimestamp()
      if (createdAt != null) 'createdAt': createdAt?.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    try {
      return Patient(
        docId: map['docId'] as String?, // ← EKLE
        firstName: map['firstName'] as String? ?? '',
        lastName: map['lastName'] as String? ?? '',
        protocolNo: map['protocolNo'] as String? ?? '',
        mainDoctorId: map['mainDoctorId'] as String? ?? '',
        createdAt: _parseDateTime(map['createdAt']),
        updatedAt: _parseDateTime(map['updatedAt']),
        pathology: map['pathology'] != null
            ? Pathology.fromMap(Map<String, dynamic>.from(map['pathology']))
            : null,
        oncology: map['oncology'] != null
            ? Oncology.fromMap(Map<String, dynamic>.from(map['oncology']))
            : null,
        demography: map['demography'] != null
            ? Demography.fromMap(Map<String, dynamic>.from(map['demography']))
            : null,
        comorbidity: map['comorbidity'] != null
            ? Comorbidity.fromMap(Map<String, dynamic>.from(map['comorbidity']))
            : null,
        biochemistry: map['biochemistry'] != null
            ? Biochemistry.fromMap(
                Map<String, dynamic>.from(map['biochemistry']),
              )
            : null,
        radiology: map['radiology'] != null
            ? Radiology.fromMap(Map<String, dynamic>.from(map['radiology']))
            : null,
        addedCategories: map['addedCategories'] != null
            ? AddedCategories.fromMap(
                Map<String, dynamic>.from(map['addedCategories']),
              )
            : null,
        authorizedUserIds: _parseStringList(map['authorizedUserIds']),
      );
    } catch (e) {
      throw Exception('Error parsing Patient from map: $e, map: $map');
    }
  }

  factory Patient.fromMapBasic(Map<String, dynamic> map) {
    try {
      return Patient(
        docId: map['docId'] as String?,
        firstName: map['firstName'] as String? ?? '',
        lastName: map['lastName'] as String? ?? '',
        protocolNo: map['protocolNo'] as String? ?? '',
        mainDoctorId: map['mainDoctorId'] as String? ?? '',
        createdAt: _parseDateTime(map['createdAt']),
        updatedAt: _parseDateTime(map['updatedAt']),
        addedCategories: map['addedCategories'] != null
            ? AddedCategories.fromMap(
                Map<String, dynamic>.from(map['addedCategories']),
              )
            : null,
        authorizedUserIds: _parseStringList(map['authorizedUserIds']),
        // Diğer fields'lar çekilmiyor, performans için
        pathology: null,
        oncology: null,
        demography: null,
        comorbidity: null,
        biochemistry: null,
        radiology: null,
      );
    } catch (e) {
      throw Exception('Error parsing Patient from map: $e, map: $map');
    }
  }

  static Map<String, dynamic> fromJsonString(String jsonString) {
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  String toJsonString() {
    final map = toMap();
    return json.encode(map);
  }

  Patient copyWith({
    String? docId,
    String? firstName,
    String? lastName,
    String? protocolNo,
    String? mainDoctorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Pathology? pathology,
    Oncology? oncology,
    Demography? demography,
    Comorbidity? comorbidity,
    Biochemistry? biochemistry,
    Radiology? radiology,
    AddedCategories? addedCategories,
    List<String>? authorizedUserIds,
  }) {
    return Patient(
      docId: docId ?? this.docId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      protocolNo: protocolNo ?? this.protocolNo,
      mainDoctorId: mainDoctorId ?? this.mainDoctorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pathology: pathology ?? this.pathology,
      oncology: oncology ?? this.oncology,
      demography: demography ?? this.demography,
      comorbidity: comorbidity ?? this.comorbidity,
      biochemistry: biochemistry ?? this.biochemistry,
      radiology: radiology ?? this.radiology,
      addedCategories: addedCategories ?? this.addedCategories,
      authorizedUserIds: authorizedUserIds ?? this.authorizedUserIds,
    );
  }

  /// Parses a Firestore array field into a typed string list
  static List<String> _parseStringList(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }

  /// Parses DateTime from various formats (Timestamp, String, or null)
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
