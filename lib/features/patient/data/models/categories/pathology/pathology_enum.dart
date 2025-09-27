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
