class Pathology {
  final String? histologicalType;
  final String? er;
  final String? pr;
  final String? her2;
  final String? molecularType;
  final String? ki67;
  final String? tubuleGrade;
  final String? nuclearGrade;
  final String? mitoticGrade;
  final String? histologicalGrade;
  final String? eCadherin;
  final String? til;

  Pathology({
    this.histologicalType,
    this.er,
    this.pr,
    this.her2,
    this.molecularType,
    this.ki67,
    this.tubuleGrade,
    this.nuclearGrade,
    this.mitoticGrade,
    this.histologicalGrade,
    this.eCadherin,
    this.til,
  });

  Map<String, dynamic> toMap() {
    return {
      'histologicalType': histologicalType,
      'er': er,
      'pr': pr,
      'her2': her2,
      'molecularType': molecularType,
      'ki67': ki67,
      'tubuleGrade': tubuleGrade,
      'nuclearGrade': nuclearGrade,
      'mitoticGrade': mitoticGrade,
      'histologicalGrade': histologicalGrade,
      'eCadherin': eCadherin,
      'til': til,
    };
  }

  factory Pathology.fromMap(Map<String, dynamic> map) {
    return Pathology(
      histologicalType: map['histologicalType'],
      er: map['er'],
      pr: map['pr'],
      her2: map['her2'],
      molecularType: map['molecularType'],
      ki67: map['ki67'],
      tubuleGrade: map['tubuleGrade'],
      nuclearGrade: map['nuclearGrade'],
      mitoticGrade: map['mitoticGrade'],
      histologicalGrade: map['histologicalGrade'],
      eCadherin: map['eCadherin'],
      til: map['til'],
    );
  }
}

/*

*/
