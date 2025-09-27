import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/services/loading_service.dart';
import 'package:flutter_medical_data_app/features/auth/data/auth_service.dart';
import 'package:flutter_medical_data_app/features/auth/domain/response_message.dart';
import 'package:flutter_medical_data_app/core/services/popup_service.dart';
import 'package:flutter_medical_data_app/core/services/navigation_service.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService;
  RegisterViewModel(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ResponseMessage? _responseMessage;
  ResponseMessage? get responseMessage => _responseMessage;
  Future<void> registerWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String passwordRepeat,
    required String name,
    required String surname,
  }) async {
    LoggerUtil.i('Register attempt: $email');
    _isLoading = true;
    _responseMessage = null;
    notifyListeners();

    // Name ve surname boş mu kontrolü
    if (name.trim().isEmpty || surname.trim().isEmpty) {
      _isLoading = false;
      _responseMessage = ResponseMessage(
        status: false,
        message: 'Ad ve soyad boş olamaz!',
      );
      notifyListeners();
      PopupService().showError(context, 'Hata', 'Ad ve soyad boş olamaz!');
      LoggerUtil.e('Ad ve soyad boş!');
      return;
    }

    // Password match kontrolü
    if (password != passwordRepeat) {
      _isLoading = false;
      _responseMessage = ResponseMessage(
        status: false,
        message: 'Şifreler eşleşmiyor!',
      );
      notifyListeners();
      PopupService().showError(context, 'Hata', 'Şifreler eşleşmiyor!');
      LoggerUtil.e('Şifreler eşleşmiyor!');
      return;
    }

    try {
      loading.show(context);
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
      notifyListeners();
      LoggerUtil.i('Kayıt başarılı!');
      NavigationService.instance.navigateTo('/home');
    } catch (e) {
      loading.close();
      _responseMessage = ResponseMessage(status: false, message: e.toString());
      notifyListeners();
      PopupService().showError(context, 'Hata', e.toString());
      LoggerUtil.e('Kayıt başarısız: $e');
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
