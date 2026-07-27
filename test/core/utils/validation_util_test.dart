import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medical_data_app/core/utils/validation_util.dart';

void main() {
  group('ValidationUtil.isValidEmail', () {
    test('geçerli email formatlarını kabul eder', () {
      expect(ValidationUtil.isValidEmail('user@example.com'), isTrue);
      expect(ValidationUtil.isValidEmail('a.b+c@sub.domain.co'), isTrue);
    });

    test('boş veya hatalı formatlı email\'i reddeder', () {
      expect(ValidationUtil.isValidEmail(''), isFalse);
      expect(ValidationUtil.isValidEmail('not-an-email'), isFalse);
      expect(ValidationUtil.isValidEmail('missing@domain'), isFalse);
      expect(ValidationUtil.isValidEmail('@nodomain.com'), isFalse);
    });
  });

  group('ValidationUtil.isValidPassword', () {
    test('minimum uzunluktaki şifreyi kabul eder', () {
      expect(ValidationUtil.isValidPassword('123456'), isTrue);
    });

    test('boş veya çok kısa şifreyi reddeder', () {
      expect(ValidationUtil.isValidPassword(''), isFalse);
      expect(ValidationUtil.isValidPassword('12345'), isFalse);
    });
  });

  group('ValidationUtil.isValidProtocolNumber', () {
    test('yalnızca rakamlardan oluşan, yeterli uzunluktaki değeri kabul eder', () {
      expect(ValidationUtil.isValidProtocolNumber('123'), isTrue);
      expect(ValidationUtil.isValidProtocolNumber('123456'), isTrue);
    });

    test('boş, çok kısa veya harf içeren değeri reddeder', () {
      expect(ValidationUtil.isValidProtocolNumber(''), isFalse);
      expect(ValidationUtil.isValidProtocolNumber('12'), isFalse);
      expect(ValidationUtil.isValidProtocolNumber('P123'), isFalse);
    });
  });

  group('ValidationUtil.doPasswordsMatch', () {
    test('aynı şifreler için true döner', () {
      expect(ValidationUtil.doPasswordsMatch('abc123', 'abc123'), isTrue);
    });

    test('farklı şifreler için false döner', () {
      expect(ValidationUtil.doPasswordsMatch('abc123', 'abc124'), isFalse);
    });
  });
}
