import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';

class ErrorHandler {
  /// Handles and logs errors, returns user-friendly message
  static String handleError(dynamic error, [String? context]) {
    String errorMessage = _getErrorMessage(error);
    String logMessage = context != null
        ? '$context: $errorMessage'
        : errorMessage;

    LoggerUtil.e(logMessage);

    return errorMessage;
  }

  /// Maps different error types to user-friendly messages
  static String _getErrorMessage(dynamic error) {
    if (error == null) return 'Bilinmeyen bir hata oluştu';

    String errorString = error.toString().toLowerCase();

    // Firebase Auth errors
    if (errorString.contains('user-not-found')) {
      return 'Kullanıcı bulunamadı';
    } else if (errorString.contains('wrong-password')) {
      return 'Yanlış şifre';
    } else if (errorString.contains('email-already-in-use')) {
      return 'Bu email adresi zaten kullanımda';
    } else if (errorString.contains('weak-password')) {
      return 'Şifre çok zayıf';
    } else if (errorString.contains('invalid-email')) {
      return 'Geçersiz email adresi';
    } else if (errorString.contains('operation-not-allowed')) {
      return 'Bu işlem şu anda mümkün değil';
    } else if (errorString.contains('too-many-requests')) {
      return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin';
    } else if (errorString.contains('network-request-failed')) {
      return 'İnternet bağlantısını kontrol edin';
    }
    // Firestore errors
    else if (errorString.contains('permission-denied')) {
      return 'Bu işlem için yetkiniz yok';
    } else if (errorString.contains('not-found')) {
      return 'Aradığınız veri bulunamadı';
    } else if (errorString.contains('already-exists')) {
      return 'Bu veri zaten mevcut';
    } else if (errorString.contains('deadline-exceeded')) {
      return 'İşlem zaman aşımına uğradı';
    } else if (errorString.contains('unavailable')) {
      return 'Servis şu anda kullanılamıyor';
    }
    // Network errors
    else if (errorString.contains('socketexception') ||
        errorString.contains('handshakeexception')) {
      return 'İnternet bağlantısı sorunu';
    }
    // Validation errors
    else if (errorString.contains('validation')) {
      return 'Girilen bilgiler geçersiz';
    }
    // Generic errors
    else if (errorString.contains('timeout')) {
      return 'İşlem zaman aşımına uğradı';
    } else if (errorString.contains('cancelled')) {
      return 'İşlem iptal edildi';
    }

    // Default message
    return 'Bir hata oluştu. Lütfen tekrar deneyin';
  }

  /// Shows error dialog
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  /// Shows error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
