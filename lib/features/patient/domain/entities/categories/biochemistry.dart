// Biochemistry enums
enum BiochemistryLevel { normal, high, low, unknown }

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
      {'index': 31, 'key': 'alp', 'values': BiochemistryLevel.values},
      {'index': 32, 'key': 'alt', 'values': BiochemistryLevel.values},
      {'index': 33, 'key': 'ast', 'values': BiochemistryLevel.values},
      {'index': 34, 'key': 'bun', 'values': BiochemistryLevel.values},
      {'index': 35, 'key': 'ca153', 'values': BiochemistryLevel.values},
      {'index': 36, 'key': 'cea', 'values': BiochemistryLevel.values},
      {'index': 37, 'key': 'crp', 'values': BiochemistryLevel.values},
      {'index': 38, 'key': 'ggt', 'values': BiochemistryLevel.values},
      {'index': 39, 'key': 'glucose', 'values': BiochemistryLevel.values},
      {'index': 40, 'key': 'hba1c', 'values': BiochemistryLevel.values},
      {'index': 41, 'key': 'creatinine', 'values': BiochemistryLevel.values},
      {'index': 42, 'key': 'ldh', 'values': BiochemistryLevel.values},
      {'index': 43, 'key': 'tsh', 'values': BiochemistryLevel.values},
      {'index': 44, 'key': 'egfr', 'values': BiochemistryLevel.values},
    ];
  }
}
