// Radiology enums
enum BiradsValue { c4c, zero, five, b4b, a4a, two, one, unknown }

enum BreastDensity { b, d, c, a, unknown }

enum Localization {
  lowerOuterQuadrant,
  otherDirections,
  retroareolarCentral,
  upperOuterQuadrant,
  upperInnerQuadrant,
  lowerInnerQuadrant,
  unknown,
}

enum LesionType {
  solidMass,
  asymmetry,
  calcification,
  architecturalDistortion,
  unknown,
}

enum ArchitecturalStructure {
  accompanyingMass,
  alone,
  accompanyingCalcification,
  unknown,
}

enum MassShape { irregular, oval, round, unknown }

enum MassContour {
  spiculated,
  smooth,
  microlobulated,
  irregular,
  indistinct,
  unknown,
}

enum MassDensity { highDensity, equalDensity, lowDensity, unknown }

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

enum CalcificationDistribution {
  linear,
  noCalcification,
  grouped,
  segmental,
  diffuse,
  regional,
  unknown,
}

enum Asymmetry {
  noAsymmetry,
  global,
  focal,
  singleProjection,
  developing,
  unknown,
}

enum MultifocalityStatus {
  noSingleFocus,
  multifocal,
  notEvaluable,
  multicentric,
  unknown,
}

enum StableMassFor2Years { unknown, no, yes, dataUnknown }

enum SkinRetraction { no, yes, singleProjectionSuspicious, unknown }

enum NippleRetraction { no, yes, singleProjectionSuspicious, unknown }

enum SurgeryHistory { no, yes, unknown }

enum CosmeticImplant { no, yes, unknown }

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
      {'index': 48, 'key': 'biradsValue', 'values': BiradsValue.values},
      {'index': 49, 'key': 'breastDensity', 'values': BreastDensity.values},
      {'index': 50, 'key': 'localization', 'values': Localization.values},
      {'index': 51, 'key': 'lesionType', 'values': LesionType.values},
      {
        'index': 52,
        'key': 'architecturalStructure',
        'values': ArchitecturalStructure.values,
      },
      {'index': 53, 'key': 'massShape', 'values': MassShape.values},
      {'index': 54, 'key': 'massContour', 'values': MassContour.values},
      {'index': 55, 'key': 'massDensity', 'values': MassDensity.values},
      {
        'index': 56,
        'key': 'calcificationMorphology',
        'values': CalcificationMorphology.values,
      },
      {
        'index': 57,
        'key': 'calcificationDistribution',
        'values': CalcificationDistribution.values,
      },
      {'index': 58, 'key': 'asymmetry', 'values': Asymmetry.values},
      {
        'index': 59,
        'key': 'multifocalityStatus',
        'values': MultifocalityStatus.values,
      },
      {
        'index': 60,
        'key': 'stableMassFor2Years',
        'values': StableMassFor2Years.values,
      },
      {'index': 61, 'key': 'skinRetraction', 'values': SkinRetraction.values},
      {
        'index': 62,
        'key': 'nippleRetraction',
        'values': NippleRetraction.values,
      },
      {'index': 63, 'key': 'surgeryHistory', 'values': SurgeryHistory.values},
      {
        'index': 64,
        'key': 'cosmeticImplant',
        'values': CosmeticImplant.values,
      },
    ];
  }
}
