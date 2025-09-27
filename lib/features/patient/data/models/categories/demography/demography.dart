class Demography {
  final String? breastSide;
  final String? bmi;
  final String? ageAtDiagnosis;
  final String? bloodType;
  final String? menopause;
  final String? sunExposure;

  Demography({
    this.breastSide,
    this.bmi,
    this.ageAtDiagnosis,
    this.bloodType,
    this.menopause,
    this.sunExposure,
  });

  Map<String, dynamic> toMap() {
    return {
      'breastSide': breastSide,
      'bmi': bmi,
      'ageAtDiagnosis': ageAtDiagnosis,
      'bloodType': bloodType,
      'menopause': menopause,
      'sunExposure': sunExposure,
    };
  }

  factory Demography.fromMap(Map<String, dynamic> map) {
    return Demography(
      breastSide: map['breastSide'],
      bmi: map['bmi'],
      ageAtDiagnosis: map['ageAtDiagnosis'],
      bloodType: map['bloodType'],
      menopause: map['menopause'],
      sunExposure: map['sunExposure'],
    );
  }
}
