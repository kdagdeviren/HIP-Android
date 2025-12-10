class UserModel {
  final String docID;
  final String ad;
  final String soyad;
  final String fcmToken;
  final bool isVerified;
  final String uploadedImage; // Base64 encoded

  UserModel({
    required this.docID,
    required this.ad,
    required this.soyad,
    required this.fcmToken,
    required this.isVerified,
    required this.uploadedImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      docID: json['docID'] as String,
      ad: json['ad'] as String,
      soyad: json['soyad'] as String,
      fcmToken: json['fcmToken'] as String,
      isVerified: json['isVerified'] as bool,
      uploadedImage: json['uploadedImage'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docID': docID,
      'ad': ad,
      'soyad': soyad,
      'fcmToken': fcmToken,
      'isVerified': isVerified,
      'uploadedImage': uploadedImage,
    };
  }
}
