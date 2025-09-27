import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';

class LoginViewmodel extends ChangeNotifier {
  final AuthService _authService;
  LoginViewmodel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ResponseMessage? _responseMessage;
  ResponseMessage? get responseMessage => _responseMessage;
  Future<void> loginWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    LoggerUtil.i('Register attempt: $email');
    _isLoading = true;
    _responseMessage = null;
    notifyListeners();

    try {
      loading.show(context);
      await _authService.loginWithEmail(email: email, password: password);

      _responseMessage = ResponseMessage(
        status: true,
        message: 'Giriş Başarılı!',
      );
      notifyListeners();
      LoggerUtil.i('Giriş başarılı!');
      NavigationService.instance.navigateTo('/home');
    } catch (e) {
      loading.close();
      _responseMessage = ResponseMessage(status: false, message: e.toString());
      notifyListeners();
      PopupService().showError(context, 'Hata', e.toString());
      LoggerUtil.e('Giriş başarısız: $e');
    } finally {
      loading.close();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    _responseMessage = null;
    notifyListeners();
  }
}
