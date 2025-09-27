class Biochemistry {
  final String? alp;
  final String? alt;
  final String? ast;
  final String? bun;
  final String? ca153;
  final String? cea;
  final String? crp;
  final String? ggt;
  final String? glucose;
  final String? hba1c;
  final String? creatinine;
  final String? ldh;
  final String? tsh;
  final String? egfr;

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
      'alp': alp,
      'alt': alt,
      'ast': ast,
      'bun': bun,
      'ca153': ca153,
      'cea': cea,
      'crp': crp,
      'ggt': ggt,
      'glucose': glucose,
      'hba1c': hba1c,
      'creatinine': creatinine,
      'ldh': ldh,
      'tsh': tsh,
      'egfr': egfr,
    };
  }

  factory Biochemistry.fromMap(Map<String, dynamic> map) {
    return Biochemistry(
      alp: map['alp'],
      alt: map['alt'],
      ast: map['ast'],
      bun: map['bun'],
      ca153: map['ca153'],
      cea: map['cea'],
      crp: map['crp'],
      ggt: map['ggt'],
      glucose: map['glucose'],
      hba1c: map['hba1c'],
      creatinine: map['creatinine'],
      ldh: map['ldh'],
      tsh: map['tsh'],
      egfr: map['egfr'],
    );
  }
}
