import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/core/utils/error_handler.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';

class LoginViewmodel extends ChangeNotifier {
  final AuthService _authService;
  LoginViewmodel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ResponseMessage? _responseMessage;
  ResponseMessage? get responseMessage => _responseMessage;

  /// Validates login form data
  String? validateLoginData(String email, String password) {
    final emailError = ValidationUtil.getEmailErrorMessage(email);
    if (emailError != null) return emailError;

    final passwordError = ValidationUtil.getPasswordErrorMessage(password);
    if (passwordError != null) return passwordError;

    return null;
  }

  /// Attempts to login with email and password
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    loading.show(context);
    LoggerUtil.i('Login attempt: $email');

    // Validate input
    final validationError = validateLoginData(email, password);
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
      await _authService.loginWithEmail(email: email, password: password);

      _responseMessage = ResponseMessage(
        status: true,
        message: 'Giriş Başarılı!',
      );
      LoggerUtil.i('Giriş başarılı!');
    } catch (e) {
      final errorMessage = ErrorHandler.handleError(e, 'Login');
      _responseMessage = ResponseMessage(status: false, message: errorMessage);
      LoggerUtil.e('Giriş başarısız: $e');
    } finally {
      _isLoading = false;

      loading.close();
      notifyListeners();
    }
  }

  void clearMessage() {
    _responseMessage = null;
    notifyListeners();
  }
}
