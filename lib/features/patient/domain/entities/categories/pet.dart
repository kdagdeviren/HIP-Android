// PET enums
enum PETResult { positive, negative, unknown }

extension PETResultExtension on PETResult {
  String get displayText {
    switch (this) {
      case PETResult.positive:
        return 'Pozitif-2';
      case PETResult.negative:
        return 'Negatif-1';
      case PETResult.unknown:
        return 'Veri Yok-0';
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
    PETResult? result;
    try {
      result = map['result'] != null
          ? PETResult.values.byName(map['result'])
          : null;
    } catch (e) {
      result = null;
    }

    return PET(result: result);
  }

  static List<Map<String, dynamic>> getDropdownConfigs() {
    return [
      {'key': 'result', 'label': 'PET Sonucu', 'values': PETResult.values},
    ];
  }
}
