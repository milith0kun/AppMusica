import 'package:flutter_test/flutter_test.dart';
import 'package:app_musica/core/utils/validators.dart';

void main() {
  group('Validators - Email', () {
    test('validates correct email', () {
      expect(Validators.validateEmail('test@example.com'), isNull);
      expect(Validators.validateEmail('user.name@domain.co.uk'), isNull);
      expect(Validators.validateEmail('test123@test.com'), isNull);
    });

    test('rejects empty email', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
      expect(Validators.validateEmail('   '), isNotNull);
    });

    test('rejects invalid email format', () {
      expect(Validators.validateEmail('invalid'), isNotNull);
      expect(Validators.validateEmail('invalid@'), isNotNull);
      expect(Validators.validateEmail('@domain.com'), isNotNull);
      expect(Validators.validateEmail('invalid@domain'), isNotNull);
      expect(Validators.validateEmail('invalid domain@test.com'), isNotNull);
    });
  });

  group('Validators - Password', () {
    test('validates correct password', () {
      expect(Validators.validatePassword('Password123'), isNull);
      expect(Validators.validatePassword('MyPass123'), isNull);
      expect(Validators.validatePassword('Test1234'), isNull);
    });

    test('rejects empty password', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('rejects short password', () {
      expect(Validators.validatePassword('Pass1'), isNotNull);
      expect(Validators.validatePassword('Test12'), isNotNull);
    });

    test('rejects password without uppercase', () {
      expect(Validators.validatePassword('password123'), isNotNull);
    });

    test('rejects password without lowercase', () {
      expect(Validators.validatePassword('PASSWORD123'), isNotNull);
    });

    test('rejects password without number', () {
      expect(Validators.validatePassword('Password'), isNotNull);
    });
  });

  group('Validators - Password Confirmation', () {
    test('validates matching passwords', () {
      expect(
        Validators.validatePasswordConfirmation('Password123', 'Password123'),
        isNull,
      );
    });

    test('rejects empty confirmation', () {
      expect(
        Validators.validatePasswordConfirmation('', 'Password123'),
        isNotNull,
      );
      expect(
        Validators.validatePasswordConfirmation(null, 'Password123'),
        isNotNull,
      );
    });

    test('rejects non-matching passwords', () {
      expect(
        Validators.validatePasswordConfirmation('Password123', 'Password456'),
        isNotNull,
      );
      expect(
        Validators.validatePasswordConfirmation('Pass123', 'Password123'),
        isNotNull,
      );
    });
  });

  group('Validators - Name', () {
    test('validates correct name', () {
      expect(Validators.validateName('John Doe'), isNull);
      expect(Validators.validateName('María García'), isNull);
      expect(Validators.validateName('José Luis'), isNull);
    });

    test('rejects empty name', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName(null), isNotNull);
      expect(Validators.validateName('   '), isNotNull);
    });

    test('rejects too short name', () {
      expect(Validators.validateName('A'), isNotNull);
    });

    test('rejects name with numbers or special chars', () {
      expect(Validators.validateName('John123'), isNotNull);
      expect(Validators.validateName('John@Doe'), isNotNull);
      expect(Validators.validateName('John_Doe'), isNotNull);
    });
  });

  group('Validators - Phone', () {
    test('validates correct phone', () {
      expect(Validators.validatePhone('+1234567890'), isNull);
      expect(Validators.validatePhone('+521234567890'), isNull);
    });

    test('allows empty phone (optional field)', () {
      expect(Validators.validatePhone(''), isNull);
      expect(Validators.validatePhone(null), isNull);
      expect(Validators.validatePhone('   '), isNull);
    });

    test('rejects invalid phone format', () {
      expect(Validators.validatePhone('123'), isNotNull);
      expect(Validators.validatePhone('abc123'), isNotNull);
      expect(Validators.validatePhone('123-456-7890'), isNotNull);
    });
  });

  group('Validators - Required Field', () {
    test('validates non-empty field', () {
      expect(Validators.validateRequired('value'), isNull);
      expect(Validators.validateRequired('test'), isNull);
    });

    test('rejects empty field', () {
      expect(Validators.validateRequired(''), isNotNull);
      expect(Validators.validateRequired(null), isNotNull);
      expect(Validators.validateRequired('   '), isNotNull);
    });

    test('uses custom field name in error message', () {
      final error = Validators.validateRequired('', fieldName: 'Nombre');
      expect(error, contains('Nombre'));
    });
  });

  group('Validators - Min Length', () {
    test('validates correct length', () {
      expect(Validators.validateMinLength('12345', 5), isNull);
      expect(Validators.validateMinLength('123456', 5), isNull);
    });

    test('allows empty (use validateRequired separately)', () {
      expect(Validators.validateMinLength('', 5), isNull);
      expect(Validators.validateMinLength(null, 5), isNull);
    });

    test('rejects too short value', () {
      expect(Validators.validateMinLength('1234', 5), isNotNull);
      expect(Validators.validateMinLength('12', 5), isNotNull);
    });
  });

  group('Validators - Max Length', () {
    test('validates correct length', () {
      expect(Validators.validateMaxLength('12345', 5), isNull);
      expect(Validators.validateMaxLength('1234', 5), isNull);
    });

    test('rejects too long value', () {
      expect(Validators.validateMaxLength('123456', 5), isNotNull);
      expect(Validators.validateMaxLength('1234567890', 5), isNotNull);
    });
  });

  group('Validators - URL', () {
    test('validates correct URL', () {
      expect(Validators.validateUrl('https://example.com'), isNull);
      expect(Validators.validateUrl('http://test.com'), isNull);
      expect(Validators.validateUrl('https://sub.domain.com/path'), isNull);
    });

    test('allows empty URL (optional)', () {
      expect(Validators.validateUrl(''), isNull);
      expect(Validators.validateUrl(null), isNull);
    });

    test('rejects invalid URL', () {
      expect(Validators.validateUrl('invalid'), isNotNull);
      expect(Validators.validateUrl('not a url'), isNotNull);
      expect(Validators.validateUrl('ftp://invalid'), isNotNull);
    });
  });

  group('Validators - Numeric', () {
    test('validates correct number', () {
      expect(Validators.validateNumeric('123'), isNull);
      expect(Validators.validateNumeric('123.45'), isNull);
      expect(Validators.validateNumeric('-123'), isNull);
    });

    test('allows empty (optional)', () {
      expect(Validators.validateNumeric(''), isNull);
      expect(Validators.validateNumeric(null), isNull);
    });

    test('rejects non-numeric', () {
      expect(Validators.validateNumeric('abc'), isNotNull);
      expect(Validators.validateNumeric('12a3'), isNotNull);
    });
  });

  group('Validators - Integer', () {
    test('validates correct integer', () {
      expect(Validators.validateInteger('123'), isNull);
      expect(Validators.validateInteger('-123'), isNull);
    });

    test('rejects decimal', () {
      expect(Validators.validateInteger('123.45'), isNotNull);
    });

    test('rejects non-integer', () {
      expect(Validators.validateInteger('abc'), isNotNull);
    });
  });

  group('Validators - Range', () {
    test('validates value in range', () {
      expect(Validators.validateRange('5', 0, 10), isNull);
      expect(Validators.validateRange('0', 0, 10), isNull);
      expect(Validators.validateRange('10', 0, 10), isNull);
    });

    test('rejects value out of range', () {
      expect(Validators.validateRange('-1', 0, 10), isNotNull);
      expect(Validators.validateRange('11', 0, 10), isNotNull);
      expect(Validators.validateRange('100', 0, 10), isNotNull);
    });
  });

  group('Validators - Age', () {
    test('validates valid age', () {
      expect(Validators.validateAge('18'), isNull);
      expect(Validators.validateAge('25'), isNull);
      expect(Validators.validateAge('65'), isNull);
    });

    test('rejects under 18', () {
      expect(Validators.validateAge('17'), isNotNull);
      expect(Validators.validateAge('10'), isNotNull);
    });

    test('rejects unrealistic age', () {
      expect(Validators.validateAge('121'), isNotNull);
      expect(Validators.validateAge('150'), isNotNull);
    });

    test('rejects empty age', () {
      expect(Validators.validateAge(''), isNotNull);
      expect(Validators.validateAge(null), isNotNull);
    });
  });

  group('Validators - Credit Card', () {
    test('validates correct card number', () {
      // Valid test card numbers
      expect(Validators.validateCreditCard('4532015112830366'), isNull);
      expect(Validators.validateCreditCard('6011111111111117'), isNull);
    });

    test('rejects empty card', () {
      expect(Validators.validateCreditCard(''), isNotNull);
      expect(Validators.validateCreditCard(null), isNotNull);
    });

    test('rejects invalid length', () {
      expect(Validators.validateCreditCard('123'), isNotNull);
      expect(Validators.validateCreditCard('12345678901234567890'), isNotNull);
    });

    test('rejects non-numeric', () {
      expect(Validators.validateCreditCard('1234-5678-9012-3456'), isNotNull);
      expect(Validators.validateCreditCard('abcd efgh ijkl mnop'), isNotNull);
    });

    test('rejects invalid checksum', () {
      expect(Validators.validateCreditCard('1234567890123456'), isNotNull);
    });
  });

  group('Validators - CVV', () {
    test('validates correct CVV', () {
      expect(Validators.validateCvv('123'), isNull);
      expect(Validators.validateCvv('1234'), isNull);
    });

    test('rejects empty CVV', () {
      expect(Validators.validateCvv(''), isNotNull);
      expect(Validators.validateCvv(null), isNotNull);
    });

    test('rejects invalid CVV', () {
      expect(Validators.validateCvv('12'), isNotNull);
      expect(Validators.validateCvv('12345'), isNotNull);
      expect(Validators.validateCvv('abc'), isNotNull);
    });
  });

  group('Validators - Expiry Date', () {
    test('validates correct expiry date', () {
      final futureYear = (DateTime.now().year % 100) + 2;
      expect(Validators.validateExpiryDate('12/$futureYear'), isNull);
      expect(Validators.validateExpiryDate('06/$futureYear'), isNull);
    });

    test('rejects empty date', () {
      expect(Validators.validateExpiryDate(''), isNotNull);
      expect(Validators.validateExpiryDate(null), isNotNull);
    });

    test('rejects invalid format', () {
      expect(Validators.validateExpiryDate('13/25'), isNotNull);
      expect(Validators.validateExpiryDate('12-25'), isNotNull);
      expect(Validators.validateExpiryDate('1225'), isNotNull);
    });

    test('rejects invalid month', () {
      expect(Validators.validateExpiryDate('00/25'), isNotNull);
      expect(Validators.validateExpiryDate('13/25'), isNotNull);
    });

    test('rejects expired date', () {
      final pastYear = (DateTime.now().year % 100) - 1;
      expect(Validators.validateExpiryDate('01/$pastYear'), isNotNull);
    });
  });

  group('Validators - Playlist Title', () {
    test('validates correct title', () {
      expect(Validators.validatePlaylistTitle('My Playlist'), isNull);
      expect(Validators.validatePlaylistTitle('Relajación'), isNull);
    });

    test('rejects empty title', () {
      expect(Validators.validatePlaylistTitle(''), isNotNull);
      expect(Validators.validatePlaylistTitle(null), isNotNull);
      expect(Validators.validatePlaylistTitle('   '), isNotNull);
    });

    test('rejects too short title', () {
      expect(Validators.validatePlaylistTitle('AB'), isNotNull);
    });

    test('rejects too long title', () {
      final longTitle = 'A' * 101;
      expect(Validators.validatePlaylistTitle(longTitle), isNotNull);
    });
  });

  group('Validators - Description', () {
    test('validates correct description', () {
      expect(Validators.validateDescription('Valid description'), isNull);
      expect(Validators.validateDescription(''), isNull); // Optional
    });

    test('rejects too long description', () {
      final longDesc = 'A' * 501;
      expect(Validators.validateDescription(longDesc), isNotNull);
    });

    test('respects custom max length', () {
      final desc = 'A' * 51;
      expect(Validators.validateDescription(desc, maxLength: 50), isNotNull);
      expect(Validators.validateDescription(desc, maxLength: 100), isNull);
    });
  });
}
