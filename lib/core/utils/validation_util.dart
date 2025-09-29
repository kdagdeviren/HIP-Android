class ValidationUtil {
  // Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Validates email format
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailRegex.hasMatch(email);
  }

  /// Validates password strength
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    if (password.length < 6) return false;
    return true;
  }

  /// Validates name field
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < 2) return false;
    if (name.length > 50) return false;
    return true;
  }

  /// Validates protocol number
  static bool isValidProtocolNumber(String protocolNumber) {
    if (protocolNumber.isEmpty) return false;
    // Protocol number should contain only digits and be at least 3 characters
    if (protocolNumber.length < 3) return false;
    return RegExp(r'^\d+$').hasMatch(protocolNumber);
  }

  /// Validates if two passwords match
  static bool doPasswordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Returns email validation error message
  static String? getEmailErrorMessage(String email) {
    if (email.isEmpty) return 'Email alanı boş olamaz';
    if (!isValidEmail(email)) return 'Geçerli bir email adresi giriniz';
    return null;
  }

  /// Returns password validation error message
  static String? getPasswordErrorMessage(String password) {
    if (password.isEmpty) return 'Şifre alanı boş olamaz';
    if (password.length < 6) return 'Şifre en az 6 karakter olmalıdır';
    return null;
  }

  /// Returns name validation error message
  static String? getNameErrorMessage(String name) {
    if (name.isEmpty) return 'Ad alanı boş olamaz';
    if (name.length < 2) return 'Ad en az 2 karakter olmalıdır';
    if (name.length > 50) return 'Ad en fazla 50 karakter olabilir';
    return null;
  }

  /// Returns protocol number validation error message
  static String? getProtocolNumberErrorMessage(String protocolNumber) {
    if (protocolNumber.isEmpty) return 'Protokol numarası boş olamaz';
    if (protocolNumber.length < 3) {
      return 'Protokol numarası en az 3 karakter olmalıdır';
    }
    if (!RegExp(r'^\d+$').hasMatch(protocolNumber)) {
      return 'Protokol numarası sadece rakam içermelidir';
    }
    return null;
  }

  /// Returns password confirmation error message
  static String? getPasswordConfirmationErrorMessage(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) return 'Şifre tekrarı boş olamaz';
    if (!doPasswordsMatch(password, confirmPassword)) {
      return 'Şifreler eşleşmiyor';
    }
    return null;
  }
}
