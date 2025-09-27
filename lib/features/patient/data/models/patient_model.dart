import 'package:flutter_medical_data_app/features/patient/data/models/categories/pet/pet.dart';

import 'categories/pathology/pathology.dart';
import 'categories/oncology/oncology.dart';
import 'categories/demography/demography.dart';
import 'categories/comorbidity/comorbidity.dart';
import 'categories/biochemistry/biochemistry.dart';
import 'categories/radiology/radiology.dart';

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String protocolNo;
  final String mainDoctorId;

  final Pathology? pathology;
  final Oncology? oncology;
  final Demography? demography;
  final Comorbidity? comorbidity;
  final Biochemistry? biochemistry;
  final Radiology? radiology;
  final PET? pet;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.protocolNo,
    required this.mainDoctorId,
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
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'protocolNo': protocolNo,
      'pathology': pathology?.toMap(),
      'oncology': oncology?.toMap(),
      'demography': demography?.toMap(),
      'comorbidity': comorbidity?.toMap(),
      'biochemistry': biochemistry?.toMap(),
      'radiology': radiology?.toMap(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      protocolNo: map['protocolNo'],
      mainDoctorId: map['mainDoctorId'],
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
    );
  }
}
