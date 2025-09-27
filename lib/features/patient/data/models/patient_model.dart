import 'package:flutter_medical_data_app/features/patient/data/models/categories/pet/pet.dart';

import 'categories/pathology/pathology.dart';
import 'categories/oncology/oncology.dart';
import 'categories/demography/demography.dart';
import 'categories/comorbidity/comorbidity.dart';
import 'categories/biochemistry/biochemistry.dart';
import 'categories/radiology/radiology.dart';

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
  final PET? pet;

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
    this.pet,
  });

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'firstName': firstName,
      'lastName': lastName,
      'protocolNo': protocolNo,
      'pathology': pathology?.toMap(),
      'oncology': oncology?.toMap(),
      'demography': demography?.toMap(),
      'comorbidity': comorbidity?.toMap(),
      'biochemistry': biochemistry?.toMap(),
      'radiology': radiology?.toMap(),
      'pet': pet?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      docId: map['docId'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      protocolNo: map['protocolNo'],
      mainDoctorId: map['mainDoctorId'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
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
          ? Biochemistry.fromMap(Map<String, dynamic>.from(map['biochemistry']))
          : null,
      radiology: map['radiology'] != null
          ? Radiology.fromMap(Map<String, dynamic>.from(map['radiology']))
          : null,
      pet: map['pet'] != null
          ? PET.fromMap(Map<String, dynamic>.from(map['pet']))
          : null,
    );
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
    PET? pet,
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
      pet: pet ?? this.pet,
    );
  }
}
