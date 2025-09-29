import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;
  RegisterViewModel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ResponseMessage? _responseMessage;
  ResponseMessage? get responseMessage => _responseMessage;

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
    if (surnameError != null) return "Soyad: ${surnameError.toLowerCase()}";

    final emailError = ValidationUtil.getEmailErrorMessage(email);
    if (emailError != null) return emailError;

    final passwordError = ValidationUtil.getPasswordErrorMessage(password);
    if (passwordError != null) return passwordError;

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
      }

      _responseMessage = ResponseMessage(
        status: true,
        message: 'Kayıt başarılı!',
      );
      LoggerUtil.i('Kayıt başarılı!');
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
