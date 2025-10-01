// Oncology enums
enum MetastasisStatus { present, absent, unknown }

extension MetastasisStatusExtension on MetastasisStatus {
  String get displayText {
    switch (this) {
      case MetastasisStatus.present:
        return 'Var';
      case MetastasisStatus.absent:
        return 'Yok';
      case MetastasisStatus.unknown:
        return 'Veri Yok';
    }
  }
}

enum MetastasisLocation { none, lymphNode, dermalLymphatic, distant, unknown }

extension MetastasisLocationExtension on MetastasisLocation {
  String get displayText {
    switch (this) {
      case MetastasisLocation.none:
        return 'Yok';
      case MetastasisLocation.lymphNode:
        return 'Lenf Nodu';
      case MetastasisLocation.dermalLymphatic:
        return 'Dermal Lenfatik';
      case MetastasisLocation.distant:
        return 'Uzak Metastaz';
      case MetastasisLocation.unknown:
        return 'Veri Yok';
    }
  }
}

enum ClinicalStage { iib, iia, ia, iiib, ib, iiia, iv, iiic, unknown }

extension ClinicalStageExtension on ClinicalStage {
  String get displayText {
    switch (this) {
      case ClinicalStage.iib:
        return 'Evre IIB';
      case ClinicalStage.iia:
        return 'Evre IIA';
      case ClinicalStage.ia:
        return 'Evre IA';
      case ClinicalStage.iiib:
        return 'Evre IIIB';
      case ClinicalStage.ib:
        return 'Evre IB';
      case ClinicalStage.iiia:
        return 'Evre IIIA';
      case ClinicalStage.iv:
        return 'Evre IV';
      case ClinicalStage.iiic:
        return 'Evre IIIC';
      case ClinicalStage.unknown:
        return 'Veri Yok';
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
        return 'Antrasiklin + Taksan';
      case ChemotherapyRegimen.taxaneOnly:
        return 'Sadece Taksan';
      case ChemotherapyRegimen.anthracyclineOnly:
        return 'Sadece Antrasiklin';
      case ChemotherapyRegimen.platinumAdded:
        return 'Platin Eklenenler';
      case ChemotherapyRegimen.unknown:
        return 'Veri Yok';
    }
  }
}

enum ChemotherapyCycleDensity { incomplete, full, intensive, unknown }

extension ChemotherapyCycleDensityExtension on ChemotherapyCycleDensity {
  String get displayText {
    switch (this) {
      case ChemotherapyCycleDensity.incomplete:
        return 'Eksik Kür';
      case ChemotherapyCycleDensity.full:
        return 'Tam Kür';
      case ChemotherapyCycleDensity.intensive:
        return 'Yoğun Kür';
      case ChemotherapyCycleDensity.unknown:
        return 'Veri Yok';
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
    return Oncology(
      metastasisStatus: map['metastasisStatus'] != null
          ? MetastasisStatus.values.byName(map['metastasisStatus'])
          : null,
      metastasisLocation: map['metastasisLocation'] != null
          ? MetastasisLocation.values.byName(map['metastasisLocation'])
          : null,
      clinicalStage: map['clinicalStage'] != null
          ? ClinicalStage.values.byName(map['clinicalStage'])
          : null,
      chemotherapyRegimen: map['chemotherapyRegimen'] != null
          ? ChemotherapyRegimen.values.byName(map['chemotherapyRegimen'])
          : null,
      chemotherapyCycleDensity: map['chemotherapyCycleDensity'] != null
          ? ChemotherapyCycleDensity.values.byName(
              map['chemotherapyCycleDensity'],
            )
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {
        'key': 'metastasisStatus',
        'label': 'Metastaz Durumu',
        'values': MetastasisStatus.values,
      },
      {
        'key': 'metastasisLocation',
        'label': 'Metastaz Yeri',
        'values': MetastasisLocation.values,
      },
      {
        'key': 'clinicalStage',
        'label': 'Klinik Evre',
        'values': ClinicalStage.values,
      },
      {
        'key': 'chemotherapyRegimen',
        'label': 'Kemoterapi Rejimi',
        'values': ChemotherapyRegimen.values,
      },
      {
        'key': 'chemotherapyCycleDensity',
        'label': 'Kemoterapi Kür Yoğunluğu',
        'values': ChemotherapyCycleDensity.values,
      },
    ];
  }
}
