import 'package:flutter/material.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';
import 'package:flutter_medical_data_app/core/utils/logger_util.dart';
import 'package:flutter_medical_data_app/l10n/app_localizations.dart';

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
    final l10n = L10n.current;
    if (error == null) return l10n.error_unknown;

    String errorString = error.toString().toLowerCase();

    // Firebase Auth errors
    if (errorString.contains('user-not-found')) {
      return l10n.error_userNotFound;
    } else if (errorString.contains('wrong-password')) {
      return l10n.error_wrongPassword;
    } else if (errorString.contains('email-already-in-use')) {
      return l10n.error_emailAlreadyInUse;
    } else if (errorString.contains('weak-password')) {
      return l10n.error_weakPassword;
    } else if (errorString.contains('invalid-email')) {
      return l10n.error_invalidEmail;
    } else if (errorString.contains('operation-not-allowed')) {
      return l10n.error_operationNotAllowed;
    } else if (errorString.contains('too-many-requests')) {
      return l10n.error_tooManyRequests;
    } else if (errorString.contains('network-request-failed')) {
      return l10n.error_networkFailed;
    }
    // Firestore errors
    else if (errorString.contains('permission-denied')) {
      return l10n.error_permissionDenied;
    } else if (errorString.contains('not-found')) {
      return l10n.error_notFound;
    } else if (errorString.contains('already-exists')) {
      return l10n.error_alreadyExists;
    } else if (errorString.contains('deadline-exceeded')) {
      return l10n.error_timeout;
    } else if (errorString.contains('unavailable')) {
      return l10n.error_unavailable;
    }
    // Network errors
    else if (errorString.contains('socketexception') ||
        errorString.contains('handshakeexception')) {
      return l10n.error_networkIssue;
    }
    // Validation errors
    else if (errorString.contains('validation')) {
      return l10n.error_validationInvalid;
    }
    // Generic errors
    else if (errorString.contains('timeout')) {
      return l10n.error_timeout;
    } else if (errorString.contains('cancelled')) {
      return l10n.error_cancelled;
    }

    // Default message
    return l10n.error_generic;
  }

  /// Shows error dialog
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.common_ok),
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
