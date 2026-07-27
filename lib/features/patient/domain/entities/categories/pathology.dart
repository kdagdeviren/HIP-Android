// Pathology enums
enum HistologicalType {
  mikstDuctalLobular,
  invasiveLobularCarcinoma,
  invasiveDuctalCarcinoma,
  otherRareTypes,
  dcis,
  unknown,
}

enum ERStatus { negative, strongPositive, weakPositive, positive, unknown }

enum PRStatus { negative, strongPositive, weakPositive, positive, unknown }

enum HER2Status { negative, positive, her2Low, equivocal, unknown }

enum MolecularType {
  tripleNegative,
  luminalA,
  luminalBHer2Positive,
  luminalBHer2Negative,
  her2Low,
  her2Enriched,
  unknown,
}

enum Ki67Level { low, medium, high, unknown }

enum TubuleGrade { grade1, grade2, grade3, unknown }

enum NuclearGrade { grade1, grade2, grade3, unknown }

enum MitoticGrade { grade1, grade2, grade3, unknown }

enum HistologicalGrade { g1, g2, g3, unknown }

enum ECadherinStatus { negative, positive, unknown }

enum TILLevel { lessThan10, between10and50, moreThan50, unknown }

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
    HistologicalType? histologicalType;
    try {
      histologicalType = map['histologicalType'] != null
          ? HistologicalType.values.byName(map['histologicalType'])
          : null;
    } catch (e) {
      histologicalType = null;
    }

    ERStatus? er;
    try {
      er = map['er'] != null ? ERStatus.values.byName(map['er']) : null;
    } catch (e) {
      er = null;
    }

    PRStatus? pr;
    try {
      pr = map['pr'] != null ? PRStatus.values.byName(map['pr']) : null;
    } catch (e) {
      pr = null;
    }

    HER2Status? her2;
    try {
      her2 = map['her2'] != null ? HER2Status.values.byName(map['her2']) : null;
    } catch (e) {
      her2 = null;
    }

    MolecularType? molecularType;
    try {
      molecularType = map['molecularType'] != null
          ? MolecularType.values.byName(map['molecularType'])
          : null;
    } catch (e) {
      molecularType = null;
    }

    Ki67Level? ki67;
    try {
      ki67 = map['ki67'] != null ? Ki67Level.values.byName(map['ki67']) : null;
    } catch (e) {
      ki67 = null;
    }

    TubuleGrade? tubuleGrade;
    try {
      tubuleGrade = map['tubuleGrade'] != null
          ? TubuleGrade.values.byName(map['tubuleGrade'])
          : null;
    } catch (e) {
      tubuleGrade = null;
    }

    NuclearGrade? nuclearGrade;
    try {
      nuclearGrade = map['nuclearGrade'] != null
          ? NuclearGrade.values.byName(map['nuclearGrade'])
          : null;
    } catch (e) {
      nuclearGrade = null;
    }

    MitoticGrade? mitoticGrade;
    try {
      mitoticGrade = map['mitoticGrade'] != null
          ? MitoticGrade.values.byName(map['mitoticGrade'])
          : null;
    } catch (e) {
      mitoticGrade = null;
    }

    HistologicalGrade? histologicalGrade;
    try {
      histologicalGrade = map['histologicalGrade'] != null
          ? HistologicalGrade.values.byName(map['histologicalGrade'])
          : null;
    } catch (e) {
      histologicalGrade = null;
    }

    ECadherinStatus? eCadherin;
    try {
      eCadherin = map['eCadherin'] != null
          ? ECadherinStatus.values.byName(map['eCadherin'])
          : null;
    } catch (e) {
      eCadherin = null;
    }

    TILLevel? til;
    try {
      til = map['til'] != null ? TILLevel.values.byName(map['til']) : null;
    } catch (e) {
      til = null;
    }

    return Pathology(
      histologicalType: histologicalType,
      er: er,
      pr: pr,
      her2: her2,
      molecularType: molecularType,
      ki67: ki67,
      tubuleGrade: tubuleGrade,
      nuclearGrade: nuclearGrade,
      mitoticGrade: mitoticGrade,
      histologicalGrade: histologicalGrade,
      eCadherin: eCadherin,
      til: til,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'index': 1, 'key': 'histologicalType', 'values': HistologicalType.values},
      {'index': 2, 'key': 'er', 'values': ERStatus.values},
      {'index': 3, 'key': 'pr', 'values': PRStatus.values},
      {'index': 4, 'key': 'her2', 'values': HER2Status.values},
      {'index': 5, 'key': 'molecularType', 'values': MolecularType.values},
      {'index': 6, 'key': 'ki67', 'values': Ki67Level.values},
      {'index': 7, 'key': 'tubuleGrade', 'values': TubuleGrade.values},
      {'index': 8, 'key': 'nuclearGrade', 'values': NuclearGrade.values},
      {'index': 9, 'key': 'mitoticGrade', 'values': MitoticGrade.values},
      {
        'index': 10,
        'key': 'histologicalGrade',
        'values': HistologicalGrade.values,
      },
      {'index': 11, 'key': 'eCadherin', 'values': ECadherinStatus.values},
      {'index': 12, 'key': 'til', 'values': TILLevel.values},
    ];
  }
}
