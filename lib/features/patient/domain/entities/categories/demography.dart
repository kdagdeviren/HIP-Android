// Demography enums
enum BreastSide { right, left, unknown }

extension BreastSideExtension on BreastSide {
  String get displayText {
    switch (this) {
      case BreastSide.right:
        return 'Sağ';
      case BreastSide.left:
        return 'Sol';
      case BreastSide.unknown:
        return 'Veri Yok';
    }
  }
}

enum BMI {
  grade2Obese,
  overweight,
  normal,
  grade1Obese,
  underweight,
  grade3Obese,
  unknown,
}

extension BMIExtension on BMI {
  String get displayText {
    switch (this) {
      case BMI.grade2Obese:
        return '2. Derece Obez';
      case BMI.overweight:
        return 'Fazla kilolu';
      case BMI.normal:
        return 'Normal kilolu';
      case BMI.grade1Obese:
        return '1. Derece Obez';
      case BMI.underweight:
        return 'Zayıf';
      case BMI.grade3Obese:
        return '3. Derece Obez';
      case BMI.unknown:
        return 'Veri Yok';
    }
  }
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

extension AgeAtDiagnosisExtension on AgeAtDiagnosis {
  String get displayText {
    switch (this) {
      case AgeAtDiagnosis.lateMiddleAge:
        return 'Geç Orta Yaş';
      case AgeAtDiagnosis.earlyMiddleAge:
        return 'Erken Orta Yaş';
      case AgeAtDiagnosis.middleAge:
        return 'Orta Yaş';
      case AgeAtDiagnosis.youngAdult:
        return 'Genç Erişkin';
      case AgeAtDiagnosis.elderly:
        return 'Yaşlı';
      case AgeAtDiagnosis.veryElderly:
        return 'İleri Yaşlı';
      case AgeAtDiagnosis.unknown:
        return 'Veri Yok';
    }
  }
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

extension BloodTypeExtension on BloodType {
  String get displayText {
    switch (this) {
      case BloodType.aPositive:
        return 'A+';
      case BloodType.bPositive:
        return 'B+';
      case BloodType.oPositive:
        return '0+';
      case BloodType.abNegative:
        return 'AB-';
      case BloodType.oNegative:
        return '0-';
      case BloodType.aNegative:
        return 'A-';
      case BloodType.abPositive:
        return 'AB+';
      case BloodType.bNegative:
        return 'B-';
      case BloodType.unknown:
        return 'Veri Yok';
    }
  }
}

enum Menopause { present, absent, unknown }

extension MenopauseExtension on Menopause {
  String get displayText {
    switch (this) {
      case Menopause.present:
        return 'Var';
      case Menopause.absent:
        return 'Yok';
      case Menopause.unknown:
        return 'Veri Yok';
    }
  }
}

enum SunExposure { high, medium, low, unknown }

extension SunExposureExtension on SunExposure {
  String get displayText {
    switch (this) {
      case SunExposure.high:
        return 'Yüksek';
      case SunExposure.medium:
        return 'Orta';
      case SunExposure.low:
        return 'Düşük';
      case SunExposure.unknown:
        return 'Veri Yok';
    }
  }
}

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
    return Demography(
      breastSide: map['breastSide'] != null
          ? BreastSide.values.byName(map['breastSide'])
          : null,
      bmi: map['bmi'] != null ? BMI.values.byName(map['bmi']) : null,
      ageAtDiagnosis: map['ageAtDiagnosis'] != null
          ? AgeAtDiagnosis.values.byName(map['ageAtDiagnosis'])
          : null,
      bloodType: map['bloodType'] != null
          ? BloodType.values.byName(map['bloodType'])
          : null,
      menopause: map['menopause'] != null
          ? Menopause.values.byName(map['menopause'])
          : null,
      sunExposure: map['sunExposure'] != null
          ? SunExposure.values.byName(map['sunExposure'])
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'key': 'breastSide', 'label': 'Hangi Meme', 'values': BreastSide.values},
      {'key': 'bmi', 'label': 'VKI', 'values': BMI.values},
      {
        'key': 'ageAtDiagnosis',
        'label': 'Tanı Yaşı',
        'values': AgeAtDiagnosis.values,
      },
      {'key': 'bloodType', 'label': 'Kan Grubu', 'values': BloodType.values},
      {'key': 'menopause', 'label': 'Menapoz', 'values': Menopause.values},
      {
        'key': 'sunExposure',
        'label': 'Güneşten Yararlanma',
        'values': SunExposure.values,
      },
    ];
  }
}
