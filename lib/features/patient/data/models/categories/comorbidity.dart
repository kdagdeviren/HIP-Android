class Comorbidity {
  final String? ht;
  final String? dm;
  final String? copd;
  final String? smoking;
  final String? familyHistoryOfBreastCa;
  final String? thyroidDisease;
  final String? retinopathy;
  final String? neuropathy;
  final String? osteoporosis;
  final String? depression;

  Comorbidity({
    this.ht,
    this.dm,
    this.copd,
    this.smoking,
    this.familyHistoryOfBreastCa,
    this.thyroidDisease,
    this.retinopathy,
    this.neuropathy,
    this.osteoporosis,
    this.depression,
  });

  Map<String, dynamic> toMap() {
    return {
      'ht': ht,
      'dm': dm,
      'copd': copd,
      'smoking': smoking,
      'familyHistoryOfBreastCa': familyHistoryOfBreastCa,
      'thyroidDisease': thyroidDisease,
      'retinopathy': retinopathy,
      'neuropathy': neuropathy,
      'osteoporosis': osteoporosis,
      'depression': depression,
    };
  }

  factory Comorbidity.fromMap(Map<String, dynamic> map) {
    return Comorbidity(
      ht: map['ht'],
      dm: map['dm'],
      copd: map['copd'],
      smoking: map['smoking'],
      familyHistoryOfBreastCa: map['familyHistoryOfBreastCa'],
      thyroidDisease: map['thyroidDisease'],
      retinopathy: map['retinopathy'],
      neuropathy: map['neuropathy'],
      osteoporosis: map['osteoporosis'],
      depression: map['depression'],
    );
  }
}
