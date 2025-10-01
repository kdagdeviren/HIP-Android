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
        return 'Mikst (Duktal + Lobüler)';
      case HistologicalType.invasiveLobularCarcinoma:
        return 'İnvaziv Lobüler Karsinom';
      case HistologicalType.invasiveDuctalCarcinoma:
        return 'İnvaziv Duktal Karsinom';
      case HistologicalType.otherRareTypes:
        return 'Diğer Nadir Tipler';
      case HistologicalType.dcis:
        return 'DCIS';
      case HistologicalType.unknown:
        return 'Veri Yok';
    }
  }
}

enum ERStatus { negative, strongPositive, weakPositive, positive, unknown }

extension ERStatusExtension on ERStatus {
  String get displayText {
    switch (this) {
      case ERStatus.negative:
        return 'Negatif';
      case ERStatus.strongPositive:
        return 'Güçlü Pozitif';
      case ERStatus.weakPositive:
        return 'Zayıf Pozitif';
      case ERStatus.positive:
        return 'Pozitif';
      case ERStatus.unknown:
        return 'Veri Yok';
    }
  }
}

enum PRStatus { negative, strongPositive, weakPositive, positive, unknown }

extension PRStatusExtension on PRStatus {
  String get displayText {
    switch (this) {
      case PRStatus.negative:
        return 'Negatif';
      case PRStatus.strongPositive:
        return 'Güçlü Pozitif';
      case PRStatus.weakPositive:
        return 'Zayıf Pozitif';
      case PRStatus.positive:
        return 'Pozitif';
      case PRStatus.unknown:
        return 'Veri Yok';
    }
  }
}

enum HER2Status { negative, positive, her2Low, equivocal, unknown }

extension HER2StatusExtension on HER2Status {
  String get displayText {
    switch (this) {
      case HER2Status.negative:
        return 'Negatif';
      case HER2Status.positive:
        return 'Pozitif';
      case HER2Status.her2Low:
        return 'HER2-düşük';
      case HER2Status.equivocal:
        return 'Ekvokal';
      case HER2Status.unknown:
        return 'Veri Yok';
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
        return 'Triple Negatif';
      case MolecularType.luminalA:
        return 'Luminal A';
      case MolecularType.luminalBHer2Positive:
        return 'Luminal B (HER2 Pozitif)';
      case MolecularType.luminalBHer2Negative:
        return 'Luminal B (HER2 Negatif)';
      case MolecularType.her2Low:
        return 'HER2-düşük';
      case MolecularType.her2Enriched:
        return 'HER2-zengin';
      case MolecularType.unknown:
        return 'Veri Yok';
    }
  }
}

enum Ki67Level { low, medium, high, unknown }

extension Ki67LevelExtension on Ki67Level {
  String get displayText {
    switch (this) {
      case Ki67Level.low:
        return 'Düşük';
      case Ki67Level.medium:
        return 'Orta';
      case Ki67Level.high:
        return 'Yüksek';
      case Ki67Level.unknown:
        return 'Veri Yok';
    }
  }
}

enum TubuleGrade { grade1, grade2, grade3, unknown }

extension TubuleGradeExtension on TubuleGrade {
  String get displayText {
    switch (this) {
      case TubuleGrade.grade1:
        return '1';
      case TubuleGrade.grade2:
        return '2';
      case TubuleGrade.grade3:
        return '3';
      case TubuleGrade.unknown:
        return 'Veri Yok';
    }
  }
}

enum NuclearGrade { grade1, grade2, grade3, unknown }

extension NuclearGradeExtension on NuclearGrade {
  String get displayText {
    switch (this) {
      case NuclearGrade.grade1:
        return '1';
      case NuclearGrade.grade2:
        return '2';
      case NuclearGrade.grade3:
        return '3';
      case NuclearGrade.unknown:
        return 'Veri Yok';
    }
  }
}

enum MitoticGrade { grade1, grade2, grade3, unknown }

extension MitoticGradeExtension on MitoticGrade {
  String get displayText {
    switch (this) {
      case MitoticGrade.grade1:
        return '1';
      case MitoticGrade.grade2:
        return '2';
      case MitoticGrade.grade3:
        return '3';
      case MitoticGrade.unknown:
        return 'Veri Yok';
    }
  }
}

enum HistologicalGrade { g1, g2, g3, unknown }

extension HistologicalGradeExtension on HistologicalGrade {
  String get displayText {
    switch (this) {
      case HistologicalGrade.g1:
        return 'G1';
      case HistologicalGrade.g2:
        return 'G2';
      case HistologicalGrade.g3:
        return 'G3';
      case HistologicalGrade.unknown:
        return 'Veri Yok';
    }
  }
}

enum ECadherinStatus { negative, positive, unknown }

extension ECadherinStatusExtension on ECadherinStatus {
  String get displayText {
    switch (this) {
      case ECadherinStatus.negative:
        return 'Negatif';
      case ECadherinStatus.positive:
        return 'Pozitif';
      case ECadherinStatus.unknown:
        return 'Veri Yok';
    }
  }
}

enum TILLevel { lessThan10, between10and50, moreThan50, unknown }

extension TILLevelExtension on TILLevel {
  String get displayText {
    switch (this) {
      case TILLevel.lessThan10:
        return '<%10';
      case TILLevel.between10and50:
        return '%10-%50';
      case TILLevel.moreThan50:
        return '>%50';
      case TILLevel.unknown:
        return 'Veri Yok';
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

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {
        'key': 'histologicalType',
        'label': 'Histolojik Tip',
        'values': HistologicalType.values,
      },
      {'key': 'er', 'label': 'ER Durumu', 'values': ERStatus.values},
      {'key': 'pr', 'label': 'PR Durumu', 'values': PRStatus.values},
      {'key': 'her2', 'label': 'HER2 Durumu', 'values': HER2Status.values},
      {
        'key': 'molecularType',
        'label': 'Moleküler Tip',
        'values': MolecularType.values,
      },
      {'key': 'ki67', 'label': 'Ki67 Seviyesi', 'values': Ki67Level.values},
      {
        'key': 'tubuleGrade',
        'label': 'Tübül Derecesi',
        'values': TubuleGrade.values,
      },
      {
        'key': 'nuclearGrade',
        'label': 'Nükleer Derece',
        'values': NuclearGrade.values,
      },
      {
        'key': 'mitoticGrade',
        'label': 'Mitotik Derece',
        'values': MitoticGrade.values,
      },
      {
        'key': 'histologicalGrade',
        'label': 'Histolojik Derece',
        'values': HistologicalGrade.values,
      },
      {
        'key': 'eCadherin',
        'label': 'E-Cadherin Durumu',
        'values': ECadherinStatus.values,
      },
      {'key': 'til', 'label': 'TIL Seviyesi', 'values': TILLevel.values},
    ];
  }
}
