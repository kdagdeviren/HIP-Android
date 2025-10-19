// Oncology enums
enum MetastasisStatus { present, absent, unknown }

extension MetastasisStatusExtension on MetastasisStatus {
  String get displayText {
    switch (this) {
      case MetastasisStatus.present:
        return 'Var-1';
      case MetastasisStatus.absent:
        return 'Yok-2';
      case MetastasisStatus.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum MetastasisLocation { none, lymphNode, dermalLymphatic, distant, unknown }

extension MetastasisLocationExtension on MetastasisLocation {
  String get displayText {
    switch (this) {
      case MetastasisLocation.none:
        return 'Yok-1';
      case MetastasisLocation.lymphNode:
        return 'Lenf Nodu-2';
      case MetastasisLocation.dermalLymphatic:
        return 'Dermal Lenfatik-3';
      case MetastasisLocation.distant:
        return 'Uzak Metastaz-4';
      case MetastasisLocation.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum ClinicalStage { iib, iia, ia, iiib, ib, iiia, iv, iiic, unknown }

extension ClinicalStageExtension on ClinicalStage {
  String get displayText {
    switch (this) {
      case ClinicalStage.iib:
        return 'Evre IIB-4';
      case ClinicalStage.iia:
        return 'Evre IIA-3';
      case ClinicalStage.ia:
        return 'Evre IA-1';
      case ClinicalStage.iiib:
        return 'Evre IIIB-6';
      case ClinicalStage.ib:
        return 'Evre IB-2';
      case ClinicalStage.iiia:
        return 'Evre IIIA-5';
      case ClinicalStage.iv:
        return 'Evre IV-8';
      case ClinicalStage.iiic:
        return 'Evre IIIC-7';
      case ClinicalStage.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum ChemotherapyRegimen {
  anthracyclinePlusTaxane,
  taxaneOnly,
  anthracyclineOnly,
  platinumAdded,
  unknown,
}

extension ChemotherapyRegimenExtension on ChemotherapyRegimen {
  String get displayText {
    switch (this) {
      case ChemotherapyRegimen.anthracyclinePlusTaxane:
        return 'Antrasiklin + Taksan-1';
      case ChemotherapyRegimen.taxaneOnly:
        return 'Sadece Taksan-3';
      case ChemotherapyRegimen.anthracyclineOnly:
        return 'Sadece Antrasiklin-2';
      case ChemotherapyRegimen.platinumAdded:
        return 'Platin Eklenenler-4';
      case ChemotherapyRegimen.unknown:
        return 'Veri Yok-0';
    }
  }
}

enum ChemotherapyCycleDensity { incomplete, full, intensive, unknown }

extension ChemotherapyCycleDensityExtension on ChemotherapyCycleDensity {
  String get displayText {
    switch (this) {
      case ChemotherapyCycleDensity.incomplete:
        return 'Eksik Kür-2';
      case ChemotherapyCycleDensity.full:
        return 'Tam Kür-1';
      case ChemotherapyCycleDensity.intensive:
        return 'Yoğun Kür-3';
      case ChemotherapyCycleDensity.unknown:
        return 'Veri Yok-0';
    }
  }
}

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
      {
        'index': 13,
        'key': 'metastasisStatus',
        'label': 'Metastaz Durumu',
        'values': MetastasisStatus.values,
      },
      {
        'index': 14,
        'key': 'metastasisLocation',
        'label': 'Metastaz Yeri',
        'values': MetastasisLocation.values,
      },
      {
        'index': 15,
        'key': 'clinicalStage',
        'label': 'Klinik Evre',
        'values': ClinicalStage.values,
      },
      {
        'index': 46,
        'key': 'chemotherapyRegimen',
        'label': 'Kemoterapi Rejimi',
        'values': ChemotherapyRegimen.values,
      },
      {
        'index': 47,
        'key': 'chemotherapyCycleDensity',
        'label': 'Kemoterapi Kür Yoğunluğu',
        'values': ChemotherapyCycleDensity.values,
      },
    ];
  }
}
