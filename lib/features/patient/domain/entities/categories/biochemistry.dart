// Biochemistry enums
enum BiochemistryLevel { normal, high, low, unknown }

extension BiochemistryLevelExtension on BiochemistryLevel {
  String get displayText {
    switch (this) {
      case BiochemistryLevel.normal:
        return 'Normal';
      case BiochemistryLevel.high:
        return 'Yüksek';
      case BiochemistryLevel.low:
        return 'Düşük';
      case BiochemistryLevel.unknown:
        return 'Veri Yok';
    }
  }
}

class Biochemistry {
  final BiochemistryLevel? alp;
  final BiochemistryLevel? alt;
  final BiochemistryLevel? ast;
  final BiochemistryLevel? bun;
  final BiochemistryLevel? ca153;
  final BiochemistryLevel? cea;
  final BiochemistryLevel? crp;
  final BiochemistryLevel? ggt;
  final BiochemistryLevel? glucose;
  final BiochemistryLevel? hba1c;
  final BiochemistryLevel? creatinine;
  final BiochemistryLevel? ldh;
  final BiochemistryLevel? tsh;
  final BiochemistryLevel? egfr;

  Biochemistry({
    this.alp,
    this.alt,
    this.ast,
    this.bun,
    this.ca153,
    this.cea,
    this.crp,
    this.ggt,
    this.glucose,
    this.hba1c,
    this.creatinine,
    this.ldh,
    this.tsh,
    this.egfr,
  });

  Map<String, dynamic> toMap() {
    return {
      'alp': alp?.name,
      'alt': alt?.name,
      'ast': ast?.name,
      'bun': bun?.name,
      'ca153': ca153?.name,
      'cea': cea?.name,
      'crp': crp?.name,
      'ggt': ggt?.name,
      'glucose': glucose?.name,
      'hba1c': hba1c?.name,
      'creatinine': creatinine?.name,
      'ldh': ldh?.name,
      'tsh': tsh?.name,
      'egfr': egfr?.name,
    };
  }

  factory Biochemistry.fromMap(Map<String, dynamic> map) {
    return Biochemistry(
      alp: map['alp'] != null
          ? BiochemistryLevel.values.byName(map['alp'])
          : null,
      alt: map['alt'] != null
          ? BiochemistryLevel.values.byName(map['alt'])
          : null,
      ast: map['ast'] != null
          ? BiochemistryLevel.values.byName(map['ast'])
          : null,
      bun: map['bun'] != null
          ? BiochemistryLevel.values.byName(map['bun'])
          : null,
      ca153: map['ca153'] != null
          ? BiochemistryLevel.values.byName(map['ca153'])
          : null,
      cea: map['cea'] != null
          ? BiochemistryLevel.values.byName(map['cea'])
          : null,
      crp: map['crp'] != null
          ? BiochemistryLevel.values.byName(map['crp'])
          : null,
      ggt: map['ggt'] != null
          ? BiochemistryLevel.values.byName(map['ggt'])
          : null,
      glucose: map['glucose'] != null
          ? BiochemistryLevel.values.byName(map['glucose'])
          : null,
      hba1c: map['hba1c'] != null
          ? BiochemistryLevel.values.byName(map['hba1c'])
          : null,
      creatinine: map['creatinine'] != null
          ? BiochemistryLevel.values.byName(map['creatinine'])
          : null,
      ldh: map['ldh'] != null
          ? BiochemistryLevel.values.byName(map['ldh'])
          : null,
      tsh: map['tsh'] != null
          ? BiochemistryLevel.values.byName(map['tsh'])
          : null,
      egfr: map['egfr'] != null
          ? BiochemistryLevel.values.byName(map['egfr'])
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'key': 'alp', 'label': 'ALP', 'values': BiochemistryLevel.values},
      {'key': 'alt', 'label': 'ALT', 'values': BiochemistryLevel.values},
      {'key': 'ast', 'label': 'AST', 'values': BiochemistryLevel.values},
      {'key': 'bun', 'label': 'BUN', 'values': BiochemistryLevel.values},
      {'key': 'ca153', 'label': 'CA15-3', 'values': BiochemistryLevel.values},
      {'key': 'cea', 'label': 'CEA', 'values': BiochemistryLevel.values},
      {'key': 'crp', 'label': 'CRP', 'values': BiochemistryLevel.values},
      {'key': 'ggt', 'label': 'GGT', 'values': BiochemistryLevel.values},
      {'key': 'glucose', 'label': 'Glukoz', 'values': BiochemistryLevel.values},
      {'key': 'hba1c', 'label': 'HbA1c', 'values': BiochemistryLevel.values},
      {
        'key': 'creatinine',
        'label': 'Kreatinin',
        'values': BiochemistryLevel.values,
      },
      {'key': 'ldh', 'label': 'LDH', 'values': BiochemistryLevel.values},
      {'key': 'tsh', 'label': 'TSH', 'values': BiochemistryLevel.values},
      {'key': 'egfr', 'label': 'e-GFR', 'values': BiochemistryLevel.values},
    ];
  }
}
