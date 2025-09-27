class Oncology {
  final String? metastasisStatus;
  final String? metastasisLocation;
  final String? clinicalStage;
  final String? chemotherapyRegimen;
  final String? chemotherapyCycleDensity;

  Oncology({
    this.metastasisStatus,
    this.metastasisLocation,
    this.clinicalStage,
    this.chemotherapyRegimen,
    this.chemotherapyCycleDensity,
  });

  Map<String, dynamic> toMap() {
    return {
      'metastasisStatus': metastasisStatus,
      'metastasisLocation': metastasisLocation,
      'clinicalStage': clinicalStage,
      'chemotherapyRegimen': chemotherapyRegimen,
      'chemotherapyCycleDensity': chemotherapyCycleDensity,
    };
  }

  factory Oncology.fromMap(Map<String, dynamic> map) {
    return Oncology(
      metastasisStatus: map['metastasisStatus'],
      metastasisLocation: map['metastasisLocation'],
      clinicalStage: map['clinicalStage'],
      chemotherapyRegimen: map['chemotherapyRegimen'],
      chemotherapyCycleDensity: map['chemotherapyCycleDensity'],
    );
  }
}
