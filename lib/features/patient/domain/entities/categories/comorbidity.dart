// Comorbidity enums
enum Presence { present, absent, unknown }

extension PresenceExtension on Presence {
  String get displayText {
    switch (this) {
      case Presence.present:
        return 'Var';
      case Presence.absent:
        return 'Yok';
      case Presence.unknown:
        return 'Veri Yok';
    }
  }
}

class Comorbidity {
  final Presence? ht;
  final Presence? dm;
  final Presence? copd;
  final Presence? smoking;
  final Presence? familyHistoryOfBreastCa;
  final Presence? thyroidDisease;
  final Presence? retinopathy;
  final Presence? neuropathy;
  final Presence? osteoporosis;
  final Presence? depression;

  Comorbidity({
    this.ht,
    this.dm,
    this.copd,
    this.smoking,
    this.familyHistoryOfBreastCa,
    this.thyroidDisease,
    this.retinopathy,
    this.neuropathy,
    this.osteoporosis,
    this.depression,
  });

  Map<String, dynamic> toMap() {
    return {
      'ht': ht?.name,
      'dm': dm?.name,
      'copd': copd?.name,
      'smoking': smoking?.name,
      'familyHistoryOfBreastCa': familyHistoryOfBreastCa?.name,
      'thyroidDisease': thyroidDisease?.name,
      'retinopathy': retinopathy?.name,
      'neuropathy': neuropathy?.name,
      'osteoporosis': osteoporosis?.name,
      'depression': depression?.name,
    };
  }

  factory Comorbidity.fromMap(Map<String, dynamic> map) {
    return Comorbidity(
      ht: map['ht'] != null ? Presence.values.byName(map['ht']) : null,
      dm: map['dm'] != null ? Presence.values.byName(map['dm']) : null,
      copd: map['copd'] != null ? Presence.values.byName(map['copd']) : null,
      smoking: map['smoking'] != null
          ? Presence.values.byName(map['smoking'])
          : null,
      familyHistoryOfBreastCa: map['familyHistoryOfBreastCa'] != null
          ? Presence.values.byName(map['familyHistoryOfBreastCa'])
          : null,
      thyroidDisease: map['thyroidDisease'] != null
          ? Presence.values.byName(map['thyroidDisease'])
          : null,
      retinopathy: map['retinopathy'] != null
          ? Presence.values.byName(map['retinopathy'])
          : null,
      neuropathy: map['neuropathy'] != null
          ? Presence.values.byName(map['neuropathy'])
          : null,
      osteoporosis: map['osteoporosis'] != null
          ? Presence.values.byName(map['osteoporosis'])
          : null,
      depression: map['depression'] != null
          ? Presence.values.byName(map['depression'])
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'key': 'ht', 'label': 'HT', 'values': Presence.values},
      {'key': 'dm', 'label': 'DM', 'values': Presence.values},
      {'key': 'copd', 'label': 'KOAH', 'values': Presence.values},
      {'key': 'smoking', 'label': 'Sigara', 'values': Presence.values},
      {
        'key': 'familyHistoryOfBreastCa',
        'label': 'Ailede Meme Kanseri Öyküsü',
        'values': Presence.values,
      },
      {
        'key': 'thyroidDisease',
        'label': 'Tiroid Hastalığı',
        'values': Presence.values,
      },
      {'key': 'retinopathy', 'label': 'Retinopati', 'values': Presence.values},
      {'key': 'neuropathy', 'label': 'Nöropati', 'values': Presence.values},
      {'key': 'osteoporosis', 'label': 'Osteoporoz', 'values': Presence.values},
      {'key': 'depression', 'label': 'Depresyon', 'values': Presence.values},
    ];
  }
}
