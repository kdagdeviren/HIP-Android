// Comorbidity enums
enum Presence { present, absent, unknown }

enum PresenceNegative { present, absent, unk }

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
    Presence? ht;
    try {
      ht = map['ht'] != null ? Presence.values.byName(map['ht']) : null;
    } catch (e) {
      ht = null;
    }

    Presence? dm;
    try {
      dm = map['dm'] != null ? Presence.values.byName(map['dm']) : null;
    } catch (e) {
      dm = null;
    }

    Presence? copd;
    try {
      copd = map['copd'] != null ? Presence.values.byName(map['copd']) : null;
    } catch (e) {
      copd = null;
    }

    Presence? smoking;
    try {
      smoking = map['smoking'] != null
          ? Presence.values.byName(map['smoking'])
          : null;
    } catch (e) {
      smoking = null;
    }

    Presence? familyHistoryOfBreastCa;
    try {
      familyHistoryOfBreastCa = map['familyHistoryOfBreastCa'] != null
          ? Presence.values.byName(map['familyHistoryOfBreastCa'])
          : null;
    } catch (e) {
      familyHistoryOfBreastCa = null;
    }

    Presence? thyroidDisease;
    try {
      thyroidDisease = map['thyroidDisease'] != null
          ? Presence.values.byName(map['thyroidDisease'])
          : null;
    } catch (e) {
      thyroidDisease = null;
    }

    Presence? retinopathy;
    try {
      retinopathy = map['retinopathy'] != null
          ? Presence.values.byName(map['retinopathy'])
          : null;
    } catch (e) {
      retinopathy = null;
    }

    Presence? neuropathy;
    try {
      neuropathy = map['neuropathy'] != null
          ? Presence.values.byName(map['neuropathy'])
          : null;
    } catch (e) {
      neuropathy = null;
    }

    Presence? osteoporosis;
    try {
      osteoporosis = map['osteoporosis'] != null
          ? Presence.values.byName(map['osteoporosis'])
          : null;
    } catch (e) {
      osteoporosis = null;
    }

    Presence? depression;
    try {
      depression = map['depression'] != null
          ? Presence.values.byName(map['depression'])
          : null;
    } catch (e) {
      depression = null;
    }

    return Comorbidity(
      ht: ht,
      dm: dm,
      copd: copd,
      smoking: smoking,
      familyHistoryOfBreastCa: familyHistoryOfBreastCa,
      thyroidDisease: thyroidDisease,
      retinopathy: retinopathy,
      neuropathy: neuropathy,
      osteoporosis: osteoporosis,
      depression: depression,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'index': 21, 'key': 'ht', 'values': Presence.values},
      {'index': 22, 'key': 'dm', 'values': Presence.values},
      {'index': 23, 'key': 'copd', 'values': PresenceNegative.values},
      {'index': 24, 'key': 'smoking', 'values': PresenceNegative.values},
      {
        'index': 25,
        'key': 'familyHistoryOfBreastCa',
        'values': Presence.values,
      },
      {
        'index': 26,
        'key': 'thyroidDisease',
        'values': PresenceNegative.values,
      },
      {'index': 27, 'key': 'retinopathy', 'values': Presence.values},
      {'index': 28, 'key': 'neuropathy', 'values': PresenceNegative.values},
      {'index': 29, 'key': 'osteoporosis', 'values': PresenceNegative.values},
      {'index': 30, 'key': 'depression', 'values': PresenceNegative.values},
    ];
  }
}

/*
HT	Var=1, Yok=2
DM	Var=1, Yok=2
KOAH	Yok=2, Var=1
Sigara	Yok=2, Var=1
Ailede Meme CA Öyküsü	Var=1, Yok=2
Tiroid	Yok=2, Var=1
Retinopati	Var=1, Yok=2
Nöropati	Yok=2, Var=1
Osteoporoz	Yok=2, Var=1
Depresyon	Yok=2, Var=1

 */
