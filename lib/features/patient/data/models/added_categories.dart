class AddedCategories {
  final bool pathology;
  final bool oncology;
  final bool demography;
  final bool comorbidity;
  final bool biochemistry;
  final bool radiology;
  final bool pet;

  AddedCategories({
    this.pathology = false,
    this.oncology = false,
    this.demography = false,
    this.comorbidity = false,
    this.biochemistry = false,
    this.radiology = false,
    this.pet = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'pathology': pathology,
      'oncology': oncology,
      'demography': demography,
      'comorbidity': comorbidity,
      'biochemistry': biochemistry,
      'radiology': radiology,
      'pet': pet,
    };
  }

  factory AddedCategories.fromMap(Map<String, dynamic> map) {
    return AddedCategories(
      pathology: map['pathology'] ?? false,
      oncology: map['oncology'] ?? false,
      demography: map['demography'] ?? false,
      comorbidity: map['comorbidity'] ?? false,
      biochemistry: map['biochemistry'] ?? false,
      radiology: map['radiology'] ?? false,
      pet: map['pet'] ?? false,
    );
  }

  AddedCategories copyWith({
    bool? pathology,
    bool? oncology,
    bool? demography,
    bool? comorbidity,
    bool? biochemistry,
    bool? radiology,
    bool? pet,
  }) {
    return AddedCategories(
      pathology: pathology ?? this.pathology,
      oncology: oncology ?? this.oncology,
      demography: demography ?? this.demography,
      comorbidity: comorbidity ?? this.comorbidity,
      biochemistry: biochemistry ?? this.biochemistry,
      radiology: radiology ?? this.radiology,
      pet: pet ?? this.pet,
    );
  }

  AddedCategories getEmpty() {
    return AddedCategories(
      pathology: false,
      oncology: false,
      demography: false,
      comorbidity: false,
      biochemistry: false,
      radiology: false,
      pet: false,
    );
  }
}
