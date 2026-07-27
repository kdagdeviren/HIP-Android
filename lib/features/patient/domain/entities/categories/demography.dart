// Demography enums
enum BreastSide { right, left, unknown }

enum BMI {
  grade2Obese,
  overweight,
  normal,
  grade1Obese,
  underweight,
  grade3Obese,
  unknown,
}

enum AgeAtDiagnosis {
  lateMiddleAge,
  earlyMiddleAge,
  middleAge,
  youngAdult,
  elderly,
  veryElderly,
  unknown,
}

enum BloodType {
  aPositive,
  bPositive,
  oPositive,
  abNegative,
  oNegative,
  aNegative,
  abPositive,
  bNegative,
  unknown,
}

enum Menopause { present, absent, unknown }

enum SunExposure { high, medium, low, unknown }

class Demography {
  final BreastSide? breastSide;
  final BMI? bmi;
  final AgeAtDiagnosis? ageAtDiagnosis;
  final BloodType? bloodType;
  final Menopause? menopause;
  final SunExposure? sunExposure;

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
      'breastSide': breastSide?.name,
      'bmi': bmi?.name,
      'ageAtDiagnosis': ageAtDiagnosis?.name,
      'bloodType': bloodType?.name,
      'menopause': menopause?.name,
      'sunExposure': sunExposure?.name,
    };
  }

  factory Demography.fromMap(Map<String, dynamic> map) {
    BreastSide? breastSide;
    try {
      breastSide = map['breastSide'] != null
          ? BreastSide.values.byName(map['breastSide'])
          : null;
    } catch (e) {
      breastSide = null;
    }

    BMI? bmi;
    try {
      bmi = map['bmi'] != null ? BMI.values.byName(map['bmi']) : null;
    } catch (e) {
      bmi = null;
    }

    AgeAtDiagnosis? ageAtDiagnosis;
    try {
      ageAtDiagnosis = map['ageAtDiagnosis'] != null
          ? AgeAtDiagnosis.values.byName(map['ageAtDiagnosis'])
          : null;
    } catch (e) {
      ageAtDiagnosis = null;
    }

    BloodType? bloodType;
    try {
      bloodType = map['bloodType'] != null
          ? BloodType.values.byName(map['bloodType'])
          : null;
    } catch (e) {
      bloodType = null;
    }

    Menopause? menopause;
    try {
      menopause = map['menopause'] != null
          ? Menopause.values.byName(map['menopause'])
          : null;
    } catch (e) {
      menopause = null;
    }

    SunExposure? sunExposure;
    try {
      sunExposure = map['sunExposure'] != null
          ? SunExposure.values.byName(map['sunExposure'])
          : null;
    } catch (e) {
      sunExposure = null;
    }

    return Demography(
      breastSide: breastSide,
      bmi: bmi,
      ageAtDiagnosis: ageAtDiagnosis,
      bloodType: bloodType,
      menopause: menopause,
      sunExposure: sunExposure,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'index': 16, 'key': 'breastSide', 'values': BreastSide.values},
      {'index': 17, 'key': 'bmi', 'values': BMI.values},
      {'index': 18, 'key': 'ageAtDiagnosis', 'values': AgeAtDiagnosis.values},
      {'index': 19, 'key': 'bloodType', 'values': BloodType.values},
      {'index': 20, 'key': 'menopause', 'values': Menopause.values},
      {'index': 45, 'key': 'sunExposure', 'values': SunExposure.values},
    ];
  }
}
