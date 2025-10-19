// Demography enums
enum BreastSide { right, left, unknown }

extension BreastSideExtension on BreastSide {
  String get displayText {
    switch (this) {
      case BreastSide.right:
        return 'Sağ-1';
      case BreastSide.left:
        return 'Sol-2';
      case BreastSide.unknown:
        return 'Veri Yok-0';
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
        return '2. Derece Obez-5';
      case BMI.overweight:
        return 'Fazla kilolu-3';
      case BMI.normal:
        return 'Normal kilolu-2';
      case BMI.grade1Obese:
        return '1. Derece Obez-4';
      case BMI.underweight:
        return 'Zayıf-1';
      case BMI.grade3Obese:
        return '3. Derece Obez-6';
      case BMI.unknown:
        return 'Veri Yok-0';
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
        return 'Geç Orta Yaş-4';
      case AgeAtDiagnosis.earlyMiddleAge:
        return 'Erken Orta Yaş-2';
      case AgeAtDiagnosis.middleAge:
        return 'Orta Yaş-3';
      case AgeAtDiagnosis.youngAdult:
        return 'Genç Erişkin-1';
      case AgeAtDiagnosis.elderly:
        return 'Yaşlı-5';
      case AgeAtDiagnosis.veryElderly:
        return 'İleri Yaşlı-6';
      case AgeAtDiagnosis.unknown:
        return 'Veri Yok-0';
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
        return 'A Pozitif-4';
      case BloodType.bPositive:
        return 'B Pozitif-6';
      case BloodType.oPositive:
        return '0 Pozitif-2';
      case BloodType.abNegative:
        return 'AB Negatif-7';
      case BloodType.oNegative:
        return '0 Negatif-1';
      case BloodType.aNegative:
        return 'A Negatif-3';
      case BloodType.abPositive:
        return 'AB Pozitif-8';
      case BloodType.bNegative:
        return 'B Negatif-5';
      case BloodType.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum Menopause { present, absent, unknown }

extension MenopauseExtension on Menopause {
  String get displayText {
    switch (this) {
      case Menopause.present:
        return 'Var-1';
      case Menopause.absent:
        return 'Yok-2';
      case Menopause.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum SunExposure { high, medium, low, unknown }

extension SunExposureExtension on SunExposure {
  String get displayText {
    switch (this) {
      case SunExposure.high:
        return 'Yüksek-3';
      case SunExposure.medium:
        return 'Orta-2';
      case SunExposure.low:
        return 'Düşük-1';
      case SunExposure.unknown:
        return 'Veri Yok-0';
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
      {
        'index': 16,
        'key': 'breastSide',
        'label': 'Hangi Meme',
        'values': BreastSide.values,
      },
      {'index': 17, 'key': 'bmi', 'label': 'VKI', 'values': BMI.values},
      {
        'index': 18,
        'key': 'ageAtDiagnosis',
        'label': 'Tanı Yaşı',
        'values': AgeAtDiagnosis.values,
      },
      {
        'index': 19,
        'key': 'bloodType',
        'label': 'Kan Grubu',
        'values': BloodType.values,
      },
      {
        'index': 20,
        'key': 'menopause',
        'label': 'Menapoz',
        'values': Menopause.values,
      },
      {
        'index': 45,
        'key': 'sunExposure',
        'label': 'Güneşten Yararlanma',
        'values': SunExposure.values,
      },
    ];
  }
}
