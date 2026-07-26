import 'package:flutter_medical_data_app/core/constants/validation_constants.dart';
import 'package:flutter_medical_data_app/core/l10n/l10n.dart';

class ValidationUtil {
  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    ValidationConstants.emailRegexPattern,
  );

  /// Validates email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email);
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    if (password.length < ValidationConstants.passwordMinLength) return false;
    return true;
  }

  /// Validates name field
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < ValidationConstants.nameMinLength) return false;
    if (name.length > ValidationConstants.nameMaxLength) return false;
    return true;
  }

  /// Validates protocol number
  static bool isValidProtocolNumber(String protocolNumber) {
    if (protocolNumber.isEmpty) return false;
    // Protocol number should contain only digits and be at least 3 characters
    if (protocolNumber.length < ValidationConstants.protocolNumberMinLength) {
      return false;
    }
    return RegExp(r'^\d+$').hasMatch(protocolNumber);
  }

  /// Validates if two passwords match
  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Returns email validation error message
  static String? getEmailErrorMessage(String email) {
    if (email.isEmpty) return ValidationConstants.emailEmptyError;
    if (!isValidEmail(email)) return ValidationConstants.emailInvalidError;
    return null;
  }

  /// Returns password validation error message
  static String? getPasswordErrorMessage(String password) {
    if (password.isEmpty) return ValidationConstants.passwordEmptyError;
    if (password.length < ValidationConstants.passwordMinLength) {
      return ValidationConstants.passwordTooShortError;
    }
    return null;
  }

  /// Returns password validation error message
  static String? getIdentityVerifyErrorMessage(bool isIdentityVerified) {
    if (isIdentityVerified == false) {
      return L10n.current.validation_identityNotVerified;
    }
    return null;
  }

  /// Returns name validation error message
  static String? getNameErrorMessage(String name) {
    if (name.isEmpty) return ValidationConstants.nameEmptyError;
    if (name.length < ValidationConstants.nameMinLength) {
      return ValidationConstants.nameTooShortError;
    }
    if (name.length > ValidationConstants.nameMaxLength) {
      return ValidationConstants.nameTooLongError;
    }
    return null;
  }

  /// Returns protocol number validation error message
  static String? getProtocolNumberErrorMessage(String protocolNumber) {
    if (protocolNumber.isEmpty) {
      return ValidationConstants.protocolNumberEmptyError;
    }
    if (protocolNumber.length < ValidationConstants.protocolNumberMinLength) {
      return ValidationConstants.protocolNumberTooShortError;
    }
    if (!RegExp(r'^\d+$').hasMatch(protocolNumber)) {
      return ValidationConstants.protocolNumberInvalidError;
    }
    return null;
  }

  /// Returns password confirmation error message
  static String? getPasswordConfirmationErrorMessage(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) {
      return ValidationConstants.passwordConfirmationEmptyError;
    }
    if (!doPasswordsMatch(password, confirmPassword)) {
      return ValidationConstants.passwordMismatchError;
    }
    return null;
  }
}
