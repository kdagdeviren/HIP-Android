// Biochemistry enums
enum BiochemistryLevel { normal, high, low, unknown }

extension BiochemistryLevelExtension on BiochemistryLevel {
  String get displayText {
    switch (this) {
      case BiochemistryLevel.normal:
        return 'Normal-1';
      case BiochemistryLevel.high:
        return 'Yüksek-3';
      case BiochemistryLevel.low:
        return 'Düşük-2';
      case BiochemistryLevel.unknown:
        return 'Veri Yok-0';
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
    BiochemistryLevel? alp;
    try {
      alp = map['alp'] != null
          ? BiochemistryLevel.values.byName(map['alp'])
          : null;
    } catch (e) {
      alp = null;
    }

    BiochemistryLevel? alt;
    try {
      alt = map['alt'] != null
          ? BiochemistryLevel.values.byName(map['alt'])
          : null;
    } catch (e) {
      alt = null;
    }

    BiochemistryLevel? ast;
    try {
      ast = map['ast'] != null
          ? BiochemistryLevel.values.byName(map['ast'])
          : null;
    } catch (e) {
      ast = null;
    }

    BiochemistryLevel? bun;
    try {
      bun = map['bun'] != null
          ? BiochemistryLevel.values.byName(map['bun'])
          : null;
    } catch (e) {
      bun = null;
    }

    BiochemistryLevel? ca153;
    try {
      ca153 = map['ca153'] != null
          ? BiochemistryLevel.values.byName(map['ca153'])
          : null;
    } catch (e) {
      ca153 = null;
    }

    BiochemistryLevel? cea;
    try {
      cea = map['cea'] != null
          ? BiochemistryLevel.values.byName(map['cea'])
          : null;
    } catch (e) {
      cea = null;
    }

    BiochemistryLevel? crp;
    try {
      crp = map['crp'] != null
          ? BiochemistryLevel.values.byName(map['crp'])
          : null;
    } catch (e) {
      crp = null;
    }

    BiochemistryLevel? ggt;
    try {
      ggt = map['ggt'] != null
          ? BiochemistryLevel.values.byName(map['ggt'])
          : null;
    } catch (e) {
      ggt = null;
    }

    BiochemistryLevel? glucose;
    try {
      glucose = map['glucose'] != null
          ? BiochemistryLevel.values.byName(map['glucose'])
          : null;
    } catch (e) {
      glucose = null;
    }

    BiochemistryLevel? hba1c;
    try {
      hba1c = map['hba1c'] != null
          ? BiochemistryLevel.values.byName(map['hba1c'])
          : null;
    } catch (e) {
      hba1c = null;
    }

    BiochemistryLevel? creatinine;
    try {
      creatinine = map['creatinine'] != null
          ? BiochemistryLevel.values.byName(map['creatinine'])
          : null;
    } catch (e) {
      creatinine = null;
    }

    BiochemistryLevel? ldh;
    try {
      ldh = map['ldh'] != null
          ? BiochemistryLevel.values.byName(map['ldh'])
          : null;
    } catch (e) {
      ldh = null;
    }

    BiochemistryLevel? tsh;
    try {
      tsh = map['tsh'] != null
          ? BiochemistryLevel.values.byName(map['tsh'])
          : null;
    } catch (e) {
      tsh = null;
    }

    BiochemistryLevel? egfr;
    try {
      egfr = map['egfr'] != null
          ? BiochemistryLevel.values.byName(map['egfr'])
          : null;
    } catch (e) {
      egfr = null;
    }

    return Biochemistry(
      alp: alp,
      alt: alt,
      ast: ast,
      bun: bun,
      ca153: ca153,
      cea: cea,
      crp: crp,
      ggt: ggt,
      glucose: glucose,
      hba1c: hba1c,
      creatinine: creatinine,
      ldh: ldh,
      tsh: tsh,
      egfr: egfr,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {
        'index': 31,
        'key': 'alp',
        'label': 'ALP',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 32,
        'key': 'alt',
        'label': 'ALT',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 33,
        'key': 'ast',
        'label': 'AST',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 34,
        'key': 'bun',
        'label': 'BUN',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 35,
        'key': 'ca153',
        'label': 'CA15-3',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 36,
        'key': 'cea',
        'label': 'CEA',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 37,
        'key': 'crp',
        'label': 'CRP',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 38,
        'key': 'ggt',
        'label': 'GGT',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 39,
        'key': 'glucose',
        'label': 'Glukoz',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 40,
        'key': 'hba1c',
        'label': 'HbA1c',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 41,
        'key': 'creatinine',
        'label': 'Kreatinin',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 42,
        'key': 'ldh',
        'label': 'LDH',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 43,
        'key': 'tsh',
        'label': 'TSH',
        'values': BiochemistryLevel.values,
      },
      {
        'index': 44,
        'key': 'egfr',
        'label': 'e-GFR',
        'values': BiochemistryLevel.values,
      },
    ];
  }
}
