class ValidationConstants {
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

  // Error messages
  static const String emailEmptyError = 'Email alanı boş olamaz';
  static const String emailInvalidError = 'Geçerli bir email adresi giriniz';
  static const String passwordEmptyError = 'Şifre alanı boş olamaz';
  static const String passwordTooShortError =
      'Şifre en az $passwordMinLength karakter olmalıdır';
  static const String passwordTooLongError =
      'Şifre en fazla $passwordMaxLength karakter olabilir';
  static const String nameEmptyError = 'Ad alanı boş olamaz';
  static const String nameTooShortError =
      'Ad en az $nameMinLength karakter olmalıdır';
  static const String nameTooLongError =
      'Ad en fazla $nameMaxLength karakter olabilir';
  static const String surnameEmptyError = 'Soyad alanı boş olamaz';
  static const String surnameTooShortError =
      'Soyad en az $surnameMinLength karakter olmalıdır';
  static const String surnameTooLongError =
      'Soyad en fazla $surnameMaxLength karakter olabilir';
  static const String protocolNumberEmptyError = 'Protokol numarası boş olamaz';
  static const String protocolNumberTooShortError =
      'Protokol numarası en az $protocolNumberMinLength karakter olmalıdır';
  static const String protocolNumberInvalidError =
      'Protokol numarası sadece rakam içermelidir';
  static const String passwordConfirmationEmptyError =
      'Şifre tekrarı boş olamaz';
  static const String passwordMismatchError = 'Şifreler eşleşmiyor';
}
