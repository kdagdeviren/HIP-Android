// Radiology enums
enum BiradsValue { c4c, zero, five, b4b, a4a, two, one, unknown }

extension BiradsValueExtension on BiradsValue {
  String get displayText {
    switch (this) {
      case BiradsValue.c4c:
        return '4C-6';
      case BiradsValue.zero:
        return '0-1';
      case BiradsValue.five:
        return '5-7';
      case BiradsValue.b4b:
        return '4B-5';
      case BiradsValue.a4a:
        return '4A-4';
      case BiradsValue.two:
        return '2-3';
      case BiradsValue.one:
        return '1-2';
      case BiradsValue.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum BreastDensity { b, d, c, a, unknown }

extension BreastDensityExtension on BreastDensity {
  String get displayText {
    switch (this) {
      case BreastDensity.b:
        return 'B-2';
      case BreastDensity.d:
        return 'D-4';
      case BreastDensity.c:
        return 'C-3';
      case BreastDensity.a:
        return 'A-1';
      case BreastDensity.unknown:
        return 'Veri Yok-0';
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
        return 'Alt Dış Kuadran (LOQ)-3';
      case Localization.otherDirections:
        return 'Diğer/Yardımcı Yönler-6';
      case Localization.retroareolarCentral:
        return 'Retroareolar / Santral-5';
      case Localization.upperOuterQuadrant:
        return 'Üst Dış Kuadran (UOQ)-1';
      case Localization.upperInnerQuadrant:
        return 'Üst İç Kuadran (UIQ)-2';
      case Localization.lowerInnerQuadrant:
        return 'Alt İç Kuadran (LIQ)-4';
      case Localization.unknown:
        return 'Veri Yok-0';
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
        return 'Solid kitle-4';
      case LesionType.asymmetry:
        return 'Asimetri-2';
      case LesionType.calcification:
        return 'Kalsifikasyon-3';
      case LesionType.architecturalDistortion:
        return 'Architectural Distortion-1';
      case LesionType.unknown:
        return 'Veri Yok-0';
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
        return 'Kitleye Eşlik Eden-2';
      case ArchitecturalStructure.alone:
        return 'Tek Başına-3';
      case ArchitecturalStructure.accompanyingCalcification:
        return 'Kalsifikasyona Eşlik Eden-1';
      case ArchitecturalStructure.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum MassShape { irregular, oval, round, unknown }

extension MassShapeExtension on MassShape {
  String get displayText {
    switch (this) {
      case MassShape.irregular:
        return 'Düzensiz-1';
      case MassShape.oval:
        return 'Oval-2';
      case MassShape.round:
        return 'Yuvarlak-3';
      case MassShape.unknown:
        return 'Veri Yok-0';
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
        return 'Spiküle-5';
      case MassContour.smooth:
        return 'Düzgün-3';
      case MassContour.microlobulated:
        return 'Mikrolobüle-4';
      case MassContour.irregular:
        return 'Düzensiz-2';
      case MassContour.indistinct:
        return 'Belirsiz-1';
      case MassContour.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum MassDensity { highDensity, equalDensity, lowDensity, unknown }

extension MassDensityExtension on MassDensity {
  String get displayText {
    switch (this) {
      case MassDensity.highDensity:
        return 'Yüksek Dansite-3';
      case MassDensity.equalDensity:
        return 'Eş Dansite-2';
      case MassDensity.lowDensity:
        return 'Düşük Dansite-1';
      case MassDensity.unknown:
        return 'Veri Yok-0';
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
        return 'Amorf-1';
      case CalcificationMorphology.noCalcification:
        return 'Kalsifikasyon Yok-4';
      case CalcificationMorphology.pleomorphic:
        return 'Pleomorfik-6';
      case CalcificationMorphology.definitelyBenign:
        return 'Kesin Benign-5';
      case CalcificationMorphology.coarsePopcorn:
        return 'Coarse/Popcorn-2';
      case CalcificationMorphology.fineLinear:
        return 'İnce Lineer-3';
      case CalcificationMorphology.roundPunctate:
        return 'Yuvarlak/Punctate-7';
      case CalcificationMorphology.unknown:
        return 'Veri Yok-0';
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
        return 'Lineer-5';
      case CalcificationDistribution.noCalcification:
        return 'Kalsifikasyon Yok-4';
      case CalcificationDistribution.grouped:
        return 'Gruplu-3';
      case CalcificationDistribution.segmental:
        return 'Segmental-6';
      case CalcificationDistribution.diffuse:
        return 'Diffüz-2';
      case CalcificationDistribution.regional:
        return 'Bölgesel-1';
      case CalcificationDistribution.unknown:
        return 'Veri Yok-0';
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
        return 'Asimetri Yok-1';
      case Asymmetry.global:
        return 'Global-4';
      case Asymmetry.focal:
        return 'Fokal-2';
      case Asymmetry.singleProjection:
        return 'Tek Projeksiyon-5';
      case Asymmetry.developing:
        return 'Gelişen-3';
      case Asymmetry.unknown:
        return 'Veri Yok-4';
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
        return 'Yok/Tek Odak-3';
      case MultifocalityStatus.multifocal:
        return 'Multifokal-1';
      case MultifocalityStatus.notEvaluable:
        return 'Değerlendirilemedi-4';
      case MultifocalityStatus.multicentric:
        return 'Multisentrik-1';
      case MultifocalityStatus.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum StableMassFor2Years { unknown, no, yes, dataUnknown }

extension StableMassFor2YearsExtension on StableMassFor2Years {
  String get displayText {
    switch (this) {
      case StableMassFor2Years.unknown:
        return 'Bilinmiyor-1';
      case StableMassFor2Years.no:
        return 'Hayır-3';
      case StableMassFor2Years.yes:
        return 'Evet-2';
      case StableMassFor2Years.dataUnknown:
        return 'Veri Yok-0';
    }
  }
}

enum SkinRetraction { no, yes, singleProjectionSuspicious, unknown }

extension SkinRetractionExtension on SkinRetraction {
  String get displayText {
    switch (this) {
      case SkinRetraction.no:
        return 'Hayır-2';
      case SkinRetraction.yes:
        return 'Evet-1';
      case SkinRetraction.singleProjectionSuspicious:
        return 'Tek Projeksiyon / Şüpheli-3';
      case SkinRetraction.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum NippleRetraction { no, yes, singleProjectionSuspicious, unknown }

extension NippleRetractionExtension on NippleRetraction {
  String get displayText {
    switch (this) {
      case NippleRetraction.no:
        return 'Hayır-2';
      case NippleRetraction.yes:
        return 'Evet-1';
      case NippleRetraction.singleProjectionSuspicious:
        return 'Tek Projeksiyon / Şüpheli-3';
      case NippleRetraction.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum SurgeryHistory { no, yes, unknown }

extension SurgeryHistoryExtension on SurgeryHistory {
  String get displayText {
    switch (this) {
      case SurgeryHistory.no:
        return 'Hayır-2';
      case SurgeryHistory.yes:
        return 'Evet-1';
      case SurgeryHistory.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum CosmeticImplant { no, yes, unknown }

extension CosmeticImplantExtension on CosmeticImplant {
  String get displayText {
    switch (this) {
      case CosmeticImplant.no:
        return 'Hayır-2';
      case CosmeticImplant.yes:
        return 'Evet-1';
      case CosmeticImplant.unknown:
        return 'Veri Yok-0';
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
    BiradsValue? biradsValue;
    try {
      biradsValue = map['biradsValue'] != null
          ? BiradsValue.values.byName(map['biradsValue'])
          : null;
    } catch (e) {
      biradsValue = null;
    }

    BreastDensity? breastDensity;
    try {
      breastDensity = map['breastDensity'] != null
          ? BreastDensity.values.byName(map['breastDensity'])
          : null;
    } catch (e) {
      breastDensity = null;
    }

    Localization? localization;
    try {
      localization = map['localization'] != null
          ? Localization.values.byName(map['localization'])
          : null;
    } catch (e) {
      localization = null;
    }

    LesionType? lesionType;
    try {
      lesionType = map['lesionType'] != null
          ? LesionType.values.byName(map['lesionType'])
          : null;
    } catch (e) {
      lesionType = null;
    }

    ArchitecturalStructure? architecturalStructure;
    try {
      architecturalStructure = map['architecturalStructure'] != null
          ? ArchitecturalStructure.values.byName(map['architecturalStructure'])
          : null;
    } catch (e) {
      architecturalStructure = null;
    }

    MassShape? massShape;
    try {
      massShape = map['massShape'] != null
          ? MassShape.values.byName(map['massShape'])
          : null;
    } catch (e) {
      massShape = null;
    }

    MassContour? massContour;
    try {
      massContour = map['massContour'] != null
          ? MassContour.values.byName(map['massContour'])
          : null;
    } catch (e) {
      massContour = null;
    }

    MassDensity? massDensity;
    try {
      massDensity = map['massDensity'] != null
          ? MassDensity.values.byName(map['massDensity'])
          : null;
    } catch (e) {
      massDensity = null;
    }

    CalcificationMorphology? calcificationMorphology;
    try {
      calcificationMorphology = map['calcificationMorphology'] != null
          ? CalcificationMorphology.values.byName(
              map['calcificationMorphology'],
            )
          : null;
    } catch (e) {
      calcificationMorphology = null;
    }

    CalcificationDistribution? calcificationDistribution;
    try {
      calcificationDistribution = map['calcificationDistribution'] != null
          ? CalcificationDistribution.values.byName(
              map['calcificationDistribution'],
            )
          : null;
    } catch (e) {
      calcificationDistribution = null;
    }

    Asymmetry? asymmetry;
    try {
      asymmetry = map['asymmetry'] != null
          ? Asymmetry.values.byName(map['asymmetry'])
          : null;
    } catch (e) {
      asymmetry = null;
    }

    MultifocalityStatus? multifocalityStatus;
    try {
      multifocalityStatus = map['multifocalityStatus'] != null
          ? MultifocalityStatus.values.byName(map['multifocalityStatus'])
          : null;
    } catch (e) {
      multifocalityStatus = null;
    }

    StableMassFor2Years? stableMassFor2Years;
    try {
      stableMassFor2Years = map['stableMassFor2Years'] != null
          ? StableMassFor2Years.values.byName(map['stableMassFor2Years'])
          : null;
    } catch (e) {
      stableMassFor2Years = null;
    }

    SkinRetraction? skinRetraction;
    try {
      skinRetraction = map['skinRetraction'] != null
          ? SkinRetraction.values.byName(map['skinRetraction'])
          : null;
    } catch (e) {
      skinRetraction = null;
    }

    NippleRetraction? nippleRetraction;
    try {
      nippleRetraction = map['nippleRetraction'] != null
          ? NippleRetraction.values.byName(map['nippleRetraction'])
          : null;
    } catch (e) {
      nippleRetraction = null;
    }

    SurgeryHistory? surgeryHistory;
    try {
      surgeryHistory = map['surgeryHistory'] != null
          ? SurgeryHistory.values.byName(map['surgeryHistory'])
          : null;
    } catch (e) {
      surgeryHistory = null;
    }

    CosmeticImplant? cosmeticImplant;
    try {
      cosmeticImplant = map['cosmeticImplant'] != null
          ? CosmeticImplant.values.byName(map['cosmeticImplant'])
          : null;
    } catch (e) {
      cosmeticImplant = null;
    }

    return Radiology(
      biradsValue: biradsValue,
      breastDensity: breastDensity,
      localization: localization,
      lesionType: lesionType,
      architecturalStructure: architecturalStructure,
      massShape: massShape,
      massContour: massContour,
      massDensity: massDensity,
      calcificationMorphology: calcificationMorphology,
      calcificationDistribution: calcificationDistribution,
      asymmetry: asymmetry,
      multifocalityStatus: multifocalityStatus,
      stableMassFor2Years: stableMassFor2Years,
      skinRetraction: skinRetraction,
      nippleRetraction: nippleRetraction,
      surgeryHistory: surgeryHistory,
      cosmeticImplant: cosmeticImplant,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {
        'index': 48,
        'key': 'biradsValue',
        'label': 'BI-RADS Değeri',
        'values': BiradsValue.values,
      },
      {
        'index': 49,
        'key': 'breastDensity',
        'label': 'Meme Dansitesi',
        'values': BreastDensity.values,
      },
      {
        'index': 50,
        'key': 'localization',
        'label': 'Lokalizasyon',
        'values': Localization.values,
      },
      {
        'index': 51,
        'key': 'lesionType',
        'label': 'Lezyon Türü',
        'values': LesionType.values,
      },
      {
        'index': 52,
        'key': 'architecturalStructure',
        'label': 'Mimari Yapı',
        'values': ArchitecturalStructure.values,
      },
      {
        'index': 53,
        'key': 'massShape',
        'label': 'Kitle Şekli',
        'values': MassShape.values,
      },
      {
        'index': 54,
        'key': 'massContour',
        'label': 'Kitle Konturu',
        'values': MassContour.values,
      },
      {
        'index': 55,
        'key': 'massDensity',
        'label': 'Kitle Dansitesi',
        'values': MassDensity.values,
      },
      {
        'index': 56,
        'key': 'calcificationMorphology',
        'label': 'Kalsifikasyon Morfolojisi',
        'values': CalcificationMorphology.values,
      },
      {
        'index': 57,
        'key': 'calcificationDistribution',
        'label': 'Kalsifikasyon Dağılımı',
        'values': CalcificationDistribution.values,
      },
      {
        'index': 58,
        'key': 'asymmetry',
        'label': 'Asimetri',
        'values': Asymmetry.values,
      },
      {
        'index': 59,
        'key': 'multifocalityStatus',
        'label': 'Multifokalite Durumu',
        'values': MultifocalityStatus.values,
      },
      {
        'index': 60,
        'key': 'stableMassFor2Years',
        'label': '2 Yıldır Stabil Kitle',
        'values': StableMassFor2Years.values,
      },
      {
        'index': 61,
        'key': 'skinRetraction',
        'label': 'Cilt Çekintisi',
        'values': SkinRetraction.values,
      },
      {
        'index': 62,
        'key': 'nippleRetraction',
        'label': 'Meme Başı Retraksiyonu',
        'values': NippleRetraction.values,
      },
      {
        'index': 63,
        'key': 'surgeryHistory',
        'label': 'Ameliyat Öyküsü',
        'values': SurgeryHistory.values,
      },
      {
        'index': 64,
        'key': 'cosmeticImplant',
        'label': 'Kozmetik İmplant',
        'values': CosmeticImplant.values,
      },
    ];
  }
}
