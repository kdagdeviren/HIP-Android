// Oncology enums
enum MetastasisStatus { present, absent, unknown }

enum MetastasisLocation { none, lymphNode, dermalLymphatic, distant, unknown }

enum ClinicalStage { iib, iia, ia, iiib, ib, iiia, iv, iiic, unknown }

enum ChemotherapyRegimen {
  anthracyclinePlusTaxane,
  taxaneOnly,
  anthracyclineOnly,
  platinumAdded,
  unknown,
}

enum ChemotherapyCycleDensity { incomplete, full, intensive, unknown }

class Oncology {
  final MetastasisStatus? metastasisStatus;
  final MetastasisLocation? metastasisLocation;
  final ClinicalStage? clinicalStage;
  final ChemotherapyRegimen? chemotherapyRegimen;
  final ChemotherapyCycleDensity? chemotherapyCycleDensity;

  Oncology({
    this.metastasisStatus,
    this.metastasisLocation,
    this.clinicalStage,
    this.chemotherapyRegimen,
    this.chemotherapyCycleDensity,
  });

  Map<String, dynamic> toMap() {
    return {
      'metastasisStatus': metastasisStatus?.name,
      'metastasisLocation': metastasisLocation?.name,
      'clinicalStage': clinicalStage?.name,
      'chemotherapyRegimen': chemotherapyRegimen?.name,
      'chemotherapyCycleDensity': chemotherapyCycleDensity?.name,
    };
  }

  factory Oncology.fromMap(Map<String, dynamic> map) {
    MetastasisStatus? metastasisStatus;
    try {
      metastasisStatus = map['metastasisStatus'] != null
          ? MetastasisStatus.values.byName(map['metastasisStatus'])
          : null;
    } catch (e) {
      metastasisStatus = null;
    }

    MetastasisLocation? metastasisLocation;
    try {
      metastasisLocation = map['metastasisLocation'] != null
          ? MetastasisLocation.values.byName(map['metastasisLocation'])
          : null;
    } catch (e) {
      metastasisLocation = null;
    }

    ClinicalStage? clinicalStage;
    try {
      clinicalStage = map['clinicalStage'] != null
          ? ClinicalStage.values.byName(map['clinicalStage'])
          : null;
    } catch (e) {
      clinicalStage = null;
    }

    ChemotherapyRegimen? chemotherapyRegimen;
    try {
      chemotherapyRegimen = map['chemotherapyRegimen'] != null
          ? ChemotherapyRegimen.values.byName(map['chemotherapyRegimen'])
          : null;
    } catch (e) {
      chemotherapyRegimen = null;
    }

    ChemotherapyCycleDensity? chemotherapyCycleDensity;
    try {
      chemotherapyCycleDensity = map['chemotherapyCycleDensity'] != null
          ? ChemotherapyCycleDensity.values.byName(
              map['chemotherapyCycleDensity'],
            )
          : null;
    } catch (e) {
      chemotherapyCycleDensity = null;
    }

    return Oncology(
      metastasisStatus: metastasisStatus,
      metastasisLocation: metastasisLocation,
      clinicalStage: clinicalStage,
      chemotherapyRegimen: chemotherapyRegimen,
      chemotherapyCycleDensity: chemotherapyCycleDensity,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'index': 13, 'key': 'metastasisStatus', 'values': MetastasisStatus.values},
      {
        'index': 14,
        'key': 'metastasisLocation',
        'values': MetastasisLocation.values,
      },
      {'index': 15, 'key': 'clinicalStage', 'values': ClinicalStage.values},
      {
        'index': 46,
        'key': 'chemotherapyRegimen',
        'values': ChemotherapyRegimen.values,
      },
      {
        'index': 47,
        'key': 'chemotherapyCycleDensity',
        'values': ChemotherapyCycleDensity.values,
      },
    ];
  }
}
