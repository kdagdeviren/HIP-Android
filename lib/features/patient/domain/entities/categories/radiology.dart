// Radiology enums
enum BiradsValue { c4c, zero, five, b4b, a4a, two, one, unknown }

extension BiradsValueExtension on BiradsValue {
  String get displayText {
    switch (this) {
      case BiradsValue.c4c:
        return '4C';
      case BiradsValue.zero:
        return '0';
      case BiradsValue.five:
        return '5';
      case BiradsValue.b4b:
        return '4B';
      case BiradsValue.a4a:
        return '4A';
      case BiradsValue.two:
        return '2';
      case BiradsValue.one:
        return '1';
      case BiradsValue.unknown:
        return 'Veri Yok';
    }
  }
}

enum BreastDensity { b, d, c, a, unknown }

extension BreastDensityExtension on BreastDensity {
  String get displayText {
    switch (this) {
      case BreastDensity.b:
        return 'B';
      case BreastDensity.d:
        return 'D';
      case BreastDensity.c:
        return 'C';
      case BreastDensity.a:
        return 'A';
      case BreastDensity.unknown:
        return 'Veri Yok';
    }
  }
}

enum Localization {
  lowerOuterQuadrant,
  otherDirections,
  retroareolarCentral,
  upperOuterQuadrant,
  upperInnerQuadrant,
  lowerInnerQuadrant,
  unknown,
}

extension LocalizationExtension on Localization {
  String get displayText {
    switch (this) {
      case Localization.lowerOuterQuadrant:
        return 'Alt Dış Kuadran (LOQ)';
      case Localization.otherDirections:
        return 'Diğer/Yardımcı Yönler';
      case Localization.retroareolarCentral:
        return 'Retroareolar / Santral';
      case Localization.upperOuterQuadrant:
        return 'Üst Dış Kuadran (UOQ)';
      case Localization.upperInnerQuadrant:
        return 'Üst İç Kuadran (UIQ)';
      case Localization.lowerInnerQuadrant:
        return 'Alt İç Kuadran (LIQ)';
      case Localization.unknown:
        return 'Veri Yok';
    }
  }
}

enum LesionType {
  solidMass,
  asymmetry,
  calcification,
  architecturalDistortion,
  unknown,
}

extension LesionTypeExtension on LesionType {
  String get displayText {
    switch (this) {
      case LesionType.solidMass:
        return 'Solid kitle';
      case LesionType.asymmetry:
        return 'Asimetri';
      case LesionType.calcification:
        return 'Kalsifikasyon';
      case LesionType.architecturalDistortion:
        return 'Architectural Distortion';
      case LesionType.unknown:
        return 'Veri Yok';
    }
  }
}

enum ArchitecturalStructure {
  accompanyingMass,
  alone,
  accompanyingCalcification,
  unknown,
}

extension ArchitecturalStructureExtension on ArchitecturalStructure {
  String get displayText {
    switch (this) {
      case ArchitecturalStructure.accompanyingMass:
        return 'Kitleye Eşlik Eden';
      case ArchitecturalStructure.alone:
        return 'Tek Başına';
      case ArchitecturalStructure.accompanyingCalcification:
        return 'Kalsifikasyona Eşlik Eden';
      case ArchitecturalStructure.unknown:
        return 'Veri Yok';
    }
  }
}

enum MassShape { irregular, oval, round, unknown }

extension MassShapeExtension on MassShape {
  String get displayText {
    switch (this) {
      case MassShape.irregular:
        return 'Düzensiz';
      case MassShape.oval:
        return 'Oval';
      case MassShape.round:
        return 'Yuvarlak';
      case MassShape.unknown:
        return 'Veri Yok';
    }
  }
}

enum MassContour {
  spiculated,
  smooth,
  microlobulated,
  irregular,
  indistinct,
  unknown,
}

extension MassContourExtension on MassContour {
  String get displayText {
    switch (this) {
      case MassContour.spiculated:
        return 'Spiküle';
      case MassContour.smooth:
        return 'Düzgün';
      case MassContour.microlobulated:
        return 'Mikrolobüle';
      case MassContour.irregular:
        return 'Düzensiz';
      case MassContour.indistinct:
        return 'Belirsiz';
      case MassContour.unknown:
        return 'Veri Yok';
    }
  }
}

enum MassDensity { highDensity, equalDensity, lowDensity, unknown }

extension MassDensityExtension on MassDensity {
  String get displayText {
    switch (this) {
      case MassDensity.highDensity:
        return 'Yüksek Dansite';
      case MassDensity.equalDensity:
        return 'Eş Dansite';
      case MassDensity.lowDensity:
        return 'Düşük Dansite';
      case MassDensity.unknown:
        return 'Veri Yok';
    }
  }
}

enum CalcificationMorphology {
  amorphous,
  noCalcification,
  pleomorphic,
  definitelyBenign,
  coarsePopcorn,
  fineLinear,
  roundPunctate,
  unknown,
}

extension CalcificationMorphologyExtension on CalcificationMorphology {
  String get displayText {
    switch (this) {
      case CalcificationMorphology.amorphous:
        return 'Amorf';
      case CalcificationMorphology.noCalcification:
        return 'Kalsifikasyon Yok';
      case CalcificationMorphology.pleomorphic:
        return 'Pleomorfik';
      case CalcificationMorphology.definitelyBenign:
        return 'Kesin Benign';
      case CalcificationMorphology.coarsePopcorn:
        return 'Coarse/Popcorn';
      case CalcificationMorphology.fineLinear:
        return 'İnce Lineer';
      case CalcificationMorphology.roundPunctate:
        return 'Yuvarlak/Punctate';
      case CalcificationMorphology.unknown:
        return 'Veri Yok';
    }
  }
}

enum CalcificationDistribution {
  linear,
  noCalcification,
  grouped,
  segmental,
  diffuse,
  regional,
  unknown,
}

extension CalcificationDistributionExtension on CalcificationDistribution {
  String get displayText {
    switch (this) {
      case CalcificationDistribution.linear:
        return 'Lineer';
      case CalcificationDistribution.noCalcification:
        return 'Kalsifikasyon Yok';
      case CalcificationDistribution.grouped:
        return 'Gruplu';
      case CalcificationDistribution.segmental:
        return 'Segmental';
      case CalcificationDistribution.diffuse:
        return 'Diffüz';
      case CalcificationDistribution.regional:
        return 'Bölgesel';
      case CalcificationDistribution.unknown:
        return 'Veri Yok';
    }
  }
}

enum Asymmetry {
  noAsymmetry,
  global,
  focal,
  singleProjection,
  developing,
  unknown,
}

extension AsymmetryExtension on Asymmetry {
  String get displayText {
    switch (this) {
      case Asymmetry.noAsymmetry:
        return 'Asimetri Yok';
      case Asymmetry.global:
        return 'Global';
      case Asymmetry.focal:
        return 'Fokal';
      case Asymmetry.singleProjection:
        return 'Tek Projeksiyon';
      case Asymmetry.developing:
        return 'Gelişen';
      case Asymmetry.unknown:
        return 'Veri Yok';
    }
  }
}

enum MultifocalityStatus {
  noSingleFocus,
  multifocal,
  notEvaluable,
  multicentric,
  unknown,
}

extension MultifocalityStatusExtension on MultifocalityStatus {
  String get displayText {
    switch (this) {
      case MultifocalityStatus.noSingleFocus:
        return 'Yok/Tek Odak';
      case MultifocalityStatus.multifocal:
        return 'Multifokal';
      case MultifocalityStatus.notEvaluable:
        return 'Değerlendirilemedi';
      case MultifocalityStatus.multicentric:
        return 'Multisentrik';
      case MultifocalityStatus.unknown:
        return 'Veri Yok';
    }
  }
}

enum StableMassFor2Years { unknown, no, yes, dataUnknown }

extension StableMassFor2YearsExtension on StableMassFor2Years {
  String get displayText {
    switch (this) {
      case StableMassFor2Years.unknown:
        return 'Bilinmiyor';
      case StableMassFor2Years.no:
        return 'Hayır';
      case StableMassFor2Years.yes:
        return 'Evet';
      case StableMassFor2Years.dataUnknown:
        return 'Veri Yok';
    }
  }
}

enum SkinRetraction { no, yes, singleProjectionSuspicious, unknown }

extension SkinRetractionExtension on SkinRetraction {
  String get displayText {
    switch (this) {
      case SkinRetraction.no:
        return 'Hayır';
      case SkinRetraction.yes:
        return 'Evet';
      case SkinRetraction.singleProjectionSuspicious:
        return 'Tek Projeksiyon - Şüpheli';
      case SkinRetraction.unknown:
        return 'Veri Yok';
    }
  }
}

enum NippleRetraction { no, yes, singleProjectionSuspicious, unknown }

extension NippleRetractionExtension on NippleRetraction {
  String get displayText {
    switch (this) {
      case NippleRetraction.no:
        return 'Hayır';
      case NippleRetraction.yes:
        return 'Evet';
      case NippleRetraction.singleProjectionSuspicious:
        return 'Tek Projeksiyon - Şüpheli';
      case NippleRetraction.unknown:
        return 'Veri Yok';
    }
  }
}

enum SurgeryHistory { no, yes, unknown }

extension SurgeryHistoryExtension on SurgeryHistory {
  String get displayText {
    switch (this) {
      case SurgeryHistory.no:
        return 'Hayır';
      case SurgeryHistory.yes:
        return 'Evet';
      case SurgeryHistory.unknown:
        return 'Veri Yok';
    }
  }
}

enum CosmeticImplant { no, yes, unknown }

extension CosmeticImplantExtension on CosmeticImplant {
  String get displayText {
    switch (this) {
      case CosmeticImplant.no:
        return 'Hayır';
      case CosmeticImplant.yes:
        return 'Evet';
      case CosmeticImplant.unknown:
        return 'Veri Yok';
    }
  }
}

class Radiology {
  final BiradsValue? biradsValue;
  final BreastDensity? breastDensity;
  final Localization? localization;
  final LesionType? lesionType;
  final ArchitecturalStructure? architecturalStructure;
  final MassShape? massShape;
  final MassContour? massContour;
  final MassDensity? massDensity;
  final CalcificationMorphology? calcificationMorphology;
  final CalcificationDistribution? calcificationDistribution;
  final Asymmetry? asymmetry;
  final MultifocalityStatus? multifocalityStatus;
  final StableMassFor2Years? stableMassFor2Years;
  final SkinRetraction? skinRetraction;
  final NippleRetraction? nippleRetraction;
  final SurgeryHistory? surgeryHistory;
  final CosmeticImplant? cosmeticImplant;

  Radiology({
    this.biradsValue,
    this.breastDensity,
    this.localization,
    this.lesionType,
    this.architecturalStructure,
    this.massShape,
    this.massContour,
    this.massDensity,
    this.calcificationMorphology,
    this.calcificationDistribution,
    this.asymmetry,
    this.multifocalityStatus,
    this.stableMassFor2Years,
    this.skinRetraction,
    this.nippleRetraction,
    this.surgeryHistory,
    this.cosmeticImplant,
  });

  Map<String, dynamic> toMap() {
    return {
      'biradsValue': biradsValue?.name,
      'breastDensity': breastDensity?.name,
      'localization': localization?.name,
      'lesionType': lesionType?.name,
      'architecturalStructure': architecturalStructure?.name,
      'massShape': massShape?.name,
      'massContour': massContour?.name,
      'massDensity': massDensity?.name,
      'calcificationMorphology': calcificationMorphology?.name,
      'calcificationDistribution': calcificationDistribution?.name,
      'asymmetry': asymmetry?.name,
      'multifocalityStatus': multifocalityStatus?.name,
      'stableMassFor2Years': stableMassFor2Years?.name,
      'skinRetraction': skinRetraction?.name,
      'nippleRetraction': nippleRetraction?.name,
      'surgeryHistory': surgeryHistory?.name,
      'cosmeticImplant': cosmeticImplant?.name,
    };
  }

  factory Radiology.fromMap(Map<String, dynamic> map) {
    return Radiology(
      biradsValue: map['biradsValue'] != null
          ? BiradsValue.values.byName(map['biradsValue'])
          : null,
      breastDensity: map['breastDensity'] != null
          ? BreastDensity.values.byName(map['breastDensity'])
          : null,
      localization: map['localization'] != null
          ? Localization.values.byName(map['localization'])
          : null,
      lesionType: map['lesionType'] != null
          ? LesionType.values.byName(map['lesionType'])
          : null,
      architecturalStructure: map['architecturalStructure'] != null
          ? ArchitecturalStructure.values.byName(map['architecturalStructure'])
          : null,
      massShape: map['massShape'] != null
          ? MassShape.values.byName(map['massShape'])
          : null,
      massContour: map['massContour'] != null
          ? MassContour.values.byName(map['massContour'])
          : null,
      massDensity: map['massDensity'] != null
          ? MassDensity.values.byName(map['massDensity'])
          : null,
      calcificationMorphology: map['calcificationMorphology'] != null
          ? CalcificationMorphology.values.byName(
              map['calcificationMorphology'],
            )
          : null,
      calcificationDistribution: map['calcificationDistribution'] != null
          ? CalcificationDistribution.values.byName(
              map['calcificationDistribution'],
            )
          : null,
      asymmetry: map['asymmetry'] != null
          ? Asymmetry.values.byName(map['asymmetry'])
          : null,
      multifocalityStatus: map['multifocalityStatus'] != null
          ? MultifocalityStatus.values.byName(map['multifocalityStatus'])
          : null,
      stableMassFor2Years: map['stableMassFor2Years'] != null
          ? StableMassFor2Years.values.byName(map['stableMassFor2Years'])
          : null,
      skinRetraction: map['skinRetraction'] != null
          ? SkinRetraction.values.byName(map['skinRetraction'])
          : null,
      nippleRetraction: map['nippleRetraction'] != null
          ? NippleRetraction.values.byName(map['nippleRetraction'])
          : null,
      surgeryHistory: map['surgeryHistory'] != null
          ? SurgeryHistory.values.byName(map['surgeryHistory'])
          : null,
      cosmeticImplant: map['cosmeticImplant'] != null
          ? CosmeticImplant.values.byName(map['cosmeticImplant'])
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {
        'key': 'biradsValue',
        'label': 'BI-RADS Değeri',
        'values': BiradsValue.values,
      },
      {
        'key': 'breastDensity',
        'label': 'Meme Dansitesi',
        'values': BreastDensity.values,
      },
      {
        'key': 'localization',
        'label': 'Lokalizasyon',
        'values': Localization.values,
      },
      {
        'key': 'lesionType',
        'label': 'Lezyon Türü',
        'values': LesionType.values,
      },
      {
        'key': 'architecturalStructure',
        'label': 'Mimari Yapı',
        'values': ArchitecturalStructure.values,
      },
      {'key': 'massShape', 'label': 'Kitle Şekli', 'values': MassShape.values},
      {
        'key': 'massContour',
        'label': 'Kitle Konturu',
        'values': MassContour.values,
      },
      {
        'key': 'massDensity',
        'label': 'Kitle Dansitesi',
        'values': MassDensity.values,
      },
      {
        'key': 'calcificationMorphology',
        'label': 'Kalsifikasyon Morfolojisi',
        'values': CalcificationMorphology.values,
      },
      {
        'key': 'calcificationDistribution',
        'label': 'Kalsifikasyon Dağılımı',
        'values': CalcificationDistribution.values,
      },
      {'key': 'asymmetry', 'label': 'Asimetri', 'values': Asymmetry.values},
      {
        'key': 'multifocalityStatus',
        'label': 'Multifokalite Durumu',
        'values': MultifocalityStatus.values,
      },
      {
        'key': 'stableMassFor2Years',
        'label': '2 Yıldır Stabil Kitle',
        'values': StableMassFor2Years.values,
      },
      {
        'key': 'skinRetraction',
        'label': 'Cilt Çekintisi',
        'values': SkinRetraction.values,
      },
      {
        'key': 'nippleRetraction',
        'label': 'Meme Başı Retraksiyonu',
        'values': NippleRetraction.values,
      },
      {
        'key': 'surgeryHistory',
        'label': 'Ameliyat Öyküsü',
        'values': SurgeryHistory.values,
      },
      {
        'key': 'cosmeticImplant',
        'label': 'Kozmetik İmplant',
        'values': CosmeticImplant.values,
      },
    ];
  }
}
