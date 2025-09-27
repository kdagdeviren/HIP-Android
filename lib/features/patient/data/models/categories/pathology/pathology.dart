import 'pathology_enum.dart';

class Pathology {
  final HistologicalType? histologicalType;
  final ERStatus? er;
  final PRStatus? pr;
  final HER2Status? her2;
  final MolecularType? molecularType;
  final Ki67Level? ki67;
  final TubuleGrade? tubuleGrade;
  final NuclearGrade? nuclearGrade;
  final MitoticGrade? mitoticGrade;
  final HistologicalGrade? histologicalGrade;
  final ECadherinStatus? eCadherin;
  final TILLevel? til;

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
      'histologicalType': histologicalType?.name,
      'er': er?.name,
      'pr': pr?.name,
      'her2': her2?.name,
      'molecularType': molecularType?.name,
      'ki67': ki67?.name,
      'tubuleGrade': tubuleGrade?.name,
      'nuclearGrade': nuclearGrade?.name,
      'mitoticGrade': mitoticGrade?.name,
      'histologicalGrade': histologicalGrade?.name,
      'eCadherin': eCadherin?.name,
      'til': til?.name,
    };
  }

  factory Pathology.fromMap(Map<String, dynamic> map) {
    return Pathology(
      histologicalType: map['histologicalType'] != null
          ? HistologicalType.values.byName(map['histologicalType'])
          : null,
      er: map['er'] != null ? ERStatus.values.byName(map['er']) : null,
      pr: map['pr'] != null ? PRStatus.values.byName(map['pr']) : null,
      her2: map['her2'] != null ? HER2Status.values.byName(map['her2']) : null,
      molecularType: map['molecularType'] != null
          ? MolecularType.values.byName(map['molecularType'])
          : null,
      ki67: map['ki67'] != null ? Ki67Level.values.byName(map['ki67']) : null,
      tubuleGrade: map['tubuleGrade'] != null
          ? TubuleGrade.values.byName(map['tubuleGrade'])
          : null,
      nuclearGrade: map['nuclearGrade'] != null
          ? NuclearGrade.values.byName(map['nuclearGrade'])
          : null,
      mitoticGrade: map['mitoticGrade'] != null
          ? MitoticGrade.values.byName(map['mitoticGrade'])
          : null,
      histologicalGrade: map['histologicalGrade'] != null
          ? HistologicalGrade.values.byName(map['histologicalGrade'])
          : null,
      eCadherin: map['eCadherin'] != null
          ? ECadherinStatus.values.byName(map['eCadherin'])
          : null,
      til: map['til'] != null ? TILLevel.values.byName(map['til']) : null,
    );
  }
}

/*

*/
