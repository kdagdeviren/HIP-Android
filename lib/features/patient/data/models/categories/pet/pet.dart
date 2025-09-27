class PET {
  final String? result;

  PET({this.result});

  Map<String, dynamic> toMap() {
    return {'result': result};
  }

  factory PET.fromMap(Map<String, dynamic> map) {
    return PET(result: map['result']);
  }
}
