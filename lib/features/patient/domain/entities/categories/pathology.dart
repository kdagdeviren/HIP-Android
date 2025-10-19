// Pathology enums
enum HistologicalType {
  mikstDuctalLobular,
  invasiveLobularCarcinoma,
  invasiveDuctalCarcinoma,
  otherRareTypes,
  dcis,
  unknown,
}

extension HistologicalTypeExtension on HistologicalType {
  String get displayText {
    switch (this) {
      case HistologicalType.mikstDuctalLobular:
        return 'Mikst (Duktal + Lobüler)-3';
      case HistologicalType.invasiveLobularCarcinoma:
        return 'İnvaziv Lobüler Karsinom-2';
      case HistologicalType.invasiveDuctalCarcinoma:
        return 'İnvaziv Duktal Karsinom-1';
      case HistologicalType.otherRareTypes:
        return 'Diğer Nadir Tipler-5';
      case HistologicalType.dcis:
        return 'DCIS-4';
      case HistologicalType.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum ERStatus { negative, strongPositive, weakPositive, positive, unknown }

extension ERStatusExtension on ERStatus {
  String get displayText {
    switch (this) {
      case ERStatus.negative:
        return 'Negatif-2';
      case ERStatus.strongPositive:
        return 'Güçlü Pozitif-1';
      case ERStatus.weakPositive:
        return 'Zayıf Pozitif-4';
      case ERStatus.positive:
        return 'Pozitif-3';
      case ERStatus.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum PRStatus { negative, strongPositive, weakPositive, positive, unknown }

extension PRStatusExtension on PRStatus {
  String get displayText {
    switch (this) {
      case PRStatus.negative:
        return 'Negatif-2';
      case PRStatus.strongPositive:
        return 'Güçlü Pozitif-1';
      case PRStatus.weakPositive:
        return 'Zayıf Pozitif-4';
      case PRStatus.positive:
        return 'Pozitif-3';
      case PRStatus.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum HER2Status { negative, positive, her2Low, equivocal, unknown }

extension HER2StatusExtension on HER2Status {
  String get displayText {
    switch (this) {
      case HER2Status.negative:
        return 'Negatif-3';
      case HER2Status.positive:
        return 'Pozitif-4';
      case HER2Status.her2Low:
        return 'HER2-düşük-2';
      case HER2Status.equivocal:
        return 'Ekvokal-1';
      case HER2Status.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum MolecularType {
  tripleNegative,
  luminalA,
  luminalBHer2Positive,
  luminalBHer2Negative,
  her2Low,
  her2Enriched,
  unknown,
}

extension MolecularTypeExtension on MolecularType {
  String get displayText {
    switch (this) {
      case MolecularType.tripleNegative:
        return 'Triple Negatif-6';
      case MolecularType.luminalA:
        return 'Luminal A-5';
      case MolecularType.luminalBHer2Positive:
        return 'Luminal B (HER2 Pozitif)-5';
      case MolecularType.luminalBHer2Negative:
        return 'Luminal B (HER2 Negatif)-4';
      case MolecularType.her2Low:
        return 'HER2-düşük-1';
      case MolecularType.her2Enriched:
        return 'HER2-zengin-2';
      case MolecularType.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum Ki67Level { low, medium, high, unknown }

extension Ki67LevelExtension on Ki67Level {
  String get displayText {
    switch (this) {
      case Ki67Level.low:
        return 'Düşük-1';
      case Ki67Level.medium:
        return 'Orta-2';
      case Ki67Level.high:
        return 'Yüksek-3';
      case Ki67Level.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum TubuleGrade { grade1, grade2, grade3, unknown }

extension TubuleGradeExtension on TubuleGrade {
  String get displayText {
    switch (this) {
      case TubuleGrade.grade1:
        return '1-1';
      case TubuleGrade.grade2:
        return '2-2';
      case TubuleGrade.grade3:
        return '3-3';
      case TubuleGrade.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum NuclearGrade { grade1, grade2, grade3, unknown }

extension NuclearGradeExtension on NuclearGrade {
  String get displayText {
    switch (this) {
      case NuclearGrade.grade1:
        return '1-1';
      case NuclearGrade.grade2:
        return '2-2';
      case NuclearGrade.grade3:
        return '3-3';
      case NuclearGrade.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum MitoticGrade { grade1, grade2, grade3, unknown }

extension MitoticGradeExtension on MitoticGrade {
  String get displayText {
    switch (this) {
      case MitoticGrade.grade1:
        return '1-1';
      case MitoticGrade.grade2:
        return '2-2';
      case MitoticGrade.grade3:
        return '3-3';
      case MitoticGrade.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum HistologicalGrade { g1, g2, g3, unknown }

extension HistologicalGradeExtension on HistologicalGrade {
  String get displayText {
    switch (this) {
      case HistologicalGrade.g1:
        return 'G1-1';
      case HistologicalGrade.g2:
        return 'G2-2';
      case HistologicalGrade.g3:
        return 'G3-3';
      case HistologicalGrade.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum ECadherinStatus { negative, positive, unknown }

extension ECadherinStatusExtension on ECadherinStatus {
  String get displayText {
    switch (this) {
      case ECadherinStatus.negative:
        return 'Negatif-2';
      case ECadherinStatus.positive:
        return 'Pozitif-1';
      case ECadherinStatus.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum TILLevel { lessThan10, between10and50, moreThan50, unknown }

extension TILLevelExtension on TILLevel {
  String get displayText {
    switch (this) {
      case TILLevel.lessThan10:
        return '<%10-1';
      case TILLevel.between10and50:
        return '%10/%50-2';
      case TILLevel.moreThan50:
        return '>%50-3';
      case TILLevel.unknown:
        return 'Veri Yok-0';
    }
  }
}

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
      {
        'index': 1,
        'key': 'histologicalType',
        'label': 'Histolojik Tip',
        'values': HistologicalType.values,
      },
      {
        'index': 2,
        'key': 'er',
        'label': 'ER Durumu',
        'values': ERStatus.values,
      },
      {
        'index': 3,
        'key': 'pr',
        'label': 'PR Durumu',
        'values': PRStatus.values,
      },
      {
        'index': 4,
        'key': 'her2',
        'label': 'HER2 Durumu',
        'values': HER2Status.values,
      },
      {
        'index': 5,
        'key': 'molecularType',
        'label': 'Moleküler Tip',
        'values': MolecularType.values,
      },
      {
        'index': 6,
        'key': 'ki67',
        'label': 'Ki67 Seviyesi',
        'values': Ki67Level.values,
      },
      {
        'index': 7,
        'key': 'tubuleGrade',
        'label': 'Tübül Derecesi',
        'values': TubuleGrade.values,
      },
      {
        'index': 8,
        'key': 'nuclearGrade',
        'label': 'Nükleer Derece',
        'values': NuclearGrade.values,
      },
      {
        'index': 9,
        'key': 'mitoticGrade',
        'label': 'Mitotik Derece',
        'values': MitoticGrade.values,
      },
      {
        'index': 10,
        'key': 'histologicalGrade',
        'label': 'Histolojik Derece',
        'values': HistologicalGrade.values,
      },
      {
        'index': 11,
        'key': 'eCadherin',
        'label': 'E-Cadherin Durumu',
        'values': ECadherinStatus.values,
      },
      {
        'index': 12,
        'key': 'til',
        'label': 'TIL Seviyesi',
        'values': TILLevel.values,
      },
    ];
  }
}
