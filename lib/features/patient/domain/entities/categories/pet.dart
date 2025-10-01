// PET enums
enum PETResult { positive, negative, unknown }

extension PETResultExtension on PETResult {
  String get displayText {
    switch (this) {
      case PETResult.positive:
        return 'Pozitif';
      case PETResult.negative:
        return 'Negatif';
      case PETResult.unknown:
        return 'Veri Yok';
    }
  }
}

class PET {
  final PETResult? result;

  PET({this.result});

  Map<String, dynamic> toMap() {
    return {'result': result?.name};
  }

  factory PET.fromMap(Map<String, dynamic> map) {
    return PET(
      result: map['result'] != null
          ? PETResult.values.byName(map['result'])
          : null,
    );
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'key': 'result', 'label': 'PET Sonucu', 'values': PETResult.values},
    ];
  }
}
