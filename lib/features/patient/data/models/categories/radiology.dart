class Radiology {
  final String? biradsValue;
  final String? breastDensity;
  final String? localization;
  final String? lesionType;
  final String? architecturalStructure;
  final String? massShape;
  final String? massContour;
  final String? massDensity;
  final String? calcificationMorphology;
  final String? calcificationDistribution;
  final String? asymmetry;
  final String? multifocalityStatus;
  final String? stableMassFor2Years;
  final String? skinRetraction;
  final String? nippleRetraction;
  final String? surgeryHistory;
  final String? cosmeticImplant;

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
      'biradsValue': biradsValue,
      'breastDensity': breastDensity,
      'localization': localization,
      'lesionType': lesionType,
      'architecturalStructure': architecturalStructure,
      'massShape': massShape,
      'massContour': massContour,
      'massDensity': massDensity,
      'calcificationMorphology': calcificationMorphology,
      'calcificationDistribution': calcificationDistribution,
      'asymmetry': asymmetry,
      'multifocalityStatus': multifocalityStatus,
      'stableMassFor2Years': stableMassFor2Years,
      'skinRetraction': skinRetraction,
      'nippleRetraction': nippleRetraction,
      'surgeryHistory': surgeryHistory,
      'cosmeticImplant': cosmeticImplant,
    };
  }

  factory Radiology.fromMap(Map<String, dynamic> map) {
    return Radiology(
      biradsValue: map['biradsValue'],
      breastDensity: map['breastDensity'],
      localization: map['localization'],
      lesionType: map['lesionType'],
      architecturalStructure: map['architecturalStructure'],
      massShape: map['massShape'],
      massContour: map['massContour'],
      massDensity: map['massDensity'],
      calcificationMorphology: map['calcificationMorphology'],
      calcificationDistribution: map['calcificationDistribution'],
      asymmetry: map['asymmetry'],
      multifocalityStatus: map['multifocalityStatus'],
      stableMassFor2Years: map['stableMassFor2Years'],
      skinRetraction: map['skinRetraction'],
      nippleRetraction: map['nippleRetraction'],
      surgeryHistory: map['surgeryHistory'],
      cosmeticImplant: map['cosmeticImplant'],
    );
  }
}
