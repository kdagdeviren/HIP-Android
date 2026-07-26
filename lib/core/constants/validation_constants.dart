import 'package:flutter_medical_data_app/core/l10n/l10n.dart';

class ValidationConstants {
  const ValidationConstants._();

  // Password constraints
  static const int passwordMinLength = 6;
  static const int passwordMaxLength = 128;

  // Name constraints
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;

  // Surname constraints
  static const int surnameMinLength = 2;
  static const int surnameMaxLength = 50;

  // Protocol number constraints
  static const int protocolNumberMinLength = 3;
  static const int protocolNumberMaxLength = 20;

  // Email regex pattern
  static const String emailRegexPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Error messages — çalışma zamanında çözülür
  static String get emailEmptyError => L10n.current.validation_emailEmpty;
  static String get emailInvalidError => L10n.current.validation_emailInvalid;
  static String get passwordEmptyError =>
      L10n.current.validation_passwordEmpty;
  static String get passwordTooShortError =>
      L10n.current.validation_passwordTooShort(passwordMinLength);
  static String get passwordTooLongError =>
      L10n.current.validation_passwordTooLong(passwordMaxLength);
  static String get nameEmptyError => L10n.current.validation_nameEmpty;
  static String get nameTooShortError =>
      L10n.current.validation_nameTooShort(nameMinLength);
  static String get nameTooLongError =>
      L10n.current.validation_nameTooLong(nameMaxLength);
  static String get surnameEmptyError => L10n.current.validation_surnameEmpty;
  static String get surnameTooShortError =>
      L10n.current.validation_surnameTooShort(surnameMinLength);
  static String get surnameTooLongError =>
      L10n.current.validation_surnameTooLong(surnameMaxLength);
  static String get protocolNumberEmptyError =>
      L10n.current.validation_protocolEmpty;
  static String get protocolNumberTooShortError =>
      L10n.current.validation_protocolTooShort(protocolNumberMinLength);
  static String get protocolNumberInvalidError =>
      L10n.current.validation_protocolInvalid;
  static String get passwordConfirmationEmptyError =>
      L10n.current.validation_passwordConfirmEmpty;
  static String get passwordMismatchError =>
      L10n.current.validation_passwordMismatch;
}
