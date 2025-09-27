import 'categories/pathology.dart';
import 'categories/oncology.dart';
import 'categories/demography.dart';
import 'categories/comorbidity.dart';
import 'categories/biochemistry.dart';
import 'categories/radiology.dart';

class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final String protocolNo;

  final Pathology? pathology;
  final Oncology? oncology;
  final Demography? demography;
  final Comorbidity? comorbidity;
  final Biochemistry? biochemistry;
  final Radiology? radiology;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.protocolNo,
    this.pathology,
    this.oncology,
    this.demography,
    this.comorbidity,
    this.biochemistry,
    this.radiology,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'protocolNo': protocolNo,
      // Category fields can be added here when implemented
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      protocolNo: map['protocolNo'],
      // Category fields can be added here when implemented
    );
  }
}
