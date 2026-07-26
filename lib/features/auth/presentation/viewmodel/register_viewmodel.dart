import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:flutter_medical_data_app/core/services/notification_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;
  RegisterViewModel(this._authService);

  bool _isLoading = false;
  bool _isIdentityVerified = false;
  XFile? _identityImage;

  bool get isLoading => _isLoading;
  bool get isIdentityVerified => _isIdentityVerified;

  ResponseMessage? _responseMessage;
  ResponseMessage? get responseMessage => _responseMessage;

  Future<String> _compressAndEncodeImage(XFile image) async {
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) throw Exception('Invalid image');

    // Resize to max 800 width
    img.Image resized = img.copyResize(originalImage, width: 800);

    // Compress with quality 85
    int quality = 85;
    List<int> compressed = img.encodeJpg(resized, quality: quality);

    // Ensure under 1MB
    while (compressed.length > 1024 * 1024 && quality > 10) {
      quality -= 10;
      compressed = img.encodeJpg(resized, quality: quality);
    }

    return base64Encode(compressed);
  }

  Future<void> changeImage(BuildContext context) async {
    loading.show(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _identityImage = pickedFile;
      _isIdentityVerified = true;
    } else {
      final l10n = AppLocalizations.of(context)!;
      PopupService().showError(
        context,
        l10n.common_error,
        l10n.auth_register_imageCaptureFailed,
      );
    }
    loading.close();
    notifyListeners();
  }

  /// Validates registration form data
  String? validateRegistrationData(
    String email,
    String password,
    String passwordRepeat,
    String name,
    String surname,
  ) {
    final nameError = ValidationUtil.getNameErrorMessage(name);
    if (nameError != null) return nameError;

    final surnameError = ValidationUtil.getNameErrorMessage(surname);
    if (surnameError != null) {
      return L10n.current.auth_register_surnamePrefix(
        surnameError.toLowerCase(),
      );
    }

    final emailError = ValidationUtil.getEmailErrorMessage(email);
    if (emailError != null) return emailError;

    final passwordError = ValidationUtil.getPasswordErrorMessage(password);
    if (passwordError != null) return passwordError;

    final identityVerifyError = ValidationUtil.getIdentityVerifyErrorMessage(
      _isIdentityVerified,
    );
    if (identityVerifyError != null) return identityVerifyError;

    final passwordConfirmError =
        ValidationUtil.getPasswordConfirmationErrorMessage(
          password,
          passwordRepeat,
        );
    if (passwordConfirmError != null) return passwordConfirmError;

    return null;
  }

  /// Attempts to register with email and password
  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String passwordRepeat,
    required String name,
    required String surname,
  }) async {
    LoggerUtil.i('Register attempt: $email');

    // Validate input
    final validationError = validateRegistrationData(
      email,
      password,
      passwordRepeat,
      name,
      surname,
    );
    if (validationError != null) {
      _responseMessage = ResponseMessage(
        status: false,
        message: validationError,
      );
      notifyListeners();
      return;
    }

    _isLoading = true;
    _responseMessage = null;
    notifyListeners();

    try {
      await _authService.registerWithEmail(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName("$name $surname");
        await user.reload();

        // Get FCM token
        String? fcmToken = await NotificationService().getToken();
        if (fcmToken == null) {
          throw Exception('FCM token alınamadı');
        }

        // Compress and encode image
        String base64Image = '';
        if (_identityImage != null) {
          base64Image = await _compressAndEncodeImage(_identityImage!);
        }

        // Create user model
        UserModel userModel = UserModel(
          docID: user.uid,
          ad: name,
          soyad: surname,
          fcmToken: fcmToken,
          isVerified: false, // Initially false
          uploadedImage: base64Image,
        );

        // Save to Firestore
        await _authService.createUser(userModel);

        _responseMessage = ResponseMessage(
          status: true,
          message: L10n.current.auth_register_successMessage,
        );
        await NotificationService().sendNotification(
          token:
              "dPRfBPYHTeK_16SNjlRmQs:APA91bEkl04aWPANWMFNTNTZYADaJRUYCM4tApSJaUozRXy6N93Fjazcgj5E613a91wKiUDxaAilsLgWQdeadKdb5-V4pHtpFz-M-0oA7-IJtaq7cWjnN4M",
          title: L10n.current.auth_register_newUserNotifTitle,
          body: L10n.current.auth_register_newUserNotifBody(name, surname),
        );
        LoggerUtil.i('Kayıt başarılı!');
      } else {
        throw Exception('Kullanıcı oluşturulamadı');
      }
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e, 'Register');
      _responseMessage = ResponseMessage(status: false, message: errorMessage);
      LoggerUtil.e('Kayıt başarısız: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _responseMessage = null;
    notifyListeners();
  }
}
