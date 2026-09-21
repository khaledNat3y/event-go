import 'package:event_ticket_booking/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterValidators.name', () {
    test('accepts a valid name of at least 2 characters', () {
      expect(RegisterValidators.name('John'), isNull);
    });

    test('rejects null', () {
      expect(RegisterValidators.name(null), 'Please enter your name');
    });

    test('rejects an empty string', () {
      expect(RegisterValidators.name(''), 'Please enter your name');
    });

    test('rejects whitespace only', () {
      expect(RegisterValidators.name('   '), 'Please enter your name');
    });

    test('rejects a single character', () {
      expect(
        RegisterValidators.name('J'),
        'Name must be at least 2 characters',
      );
    });

    test('trims surrounding whitespace before validating', () {
      expect(RegisterValidators.name('  a  '), 'Name must be at least 2 characters');
      expect(RegisterValidators.name('  Jo  '), isNull);
    });
  });

  group('RegisterValidators.email', () {
    test('accepts a valid email', () {
      expect(RegisterValidators.email('user@example.com'), isNull);
    });

    test('rejects an email with a plus tag', () {
      expect(
        RegisterValidators.email('user+tag@example.co'),
        'Please enter a valid email',
      );
    });

    test('rejects null', () {
      expect(RegisterValidators.email(null), 'Please enter your email');
    });

    test('rejects an empty string', () {
      expect(RegisterValidators.email(''), 'Please enter your email');
    });

    test('rejects whitespace only', () {
      expect(RegisterValidators.email('   '), 'Please enter your email');
    });

    test('rejects an email without an @', () {
      expect(RegisterValidators.email('userexample.com'), 'Please enter a valid email');
    });

    test('rejects an email without a domain', () {
      expect(RegisterValidators.email('user@'), 'Please enter a valid email');
    });

    test('rejects an email with spaces', () {
      expect(RegisterValidators.email('user @example.com'), 'Please enter a valid email');
    });

    test('trims surrounding whitespace', () {
      expect(RegisterValidators.email('  user@example.com  '), isNull);
    });
  });

  group('RegisterValidators.password', () {
    test('accepts a password meeting all rules', () {
      expect(RegisterValidators.password('Password1'), isNull);
    });

    test('rejects null', () {
      expect(RegisterValidators.password(null), 'Please enter a password');
    });

    test('rejects an empty string', () {
      expect(RegisterValidators.password(''), 'Please enter a password');
    });

    test('rejects a short password', () {
      expect(
        RegisterValidators.password('Ab1'),
        'Password must be at least 8 characters',
      );
    });

    test('rejects a password without an uppercase letter', () {
      expect(
        RegisterValidators.password('password1'),
        'Password must contain at least one uppercase letter',
      );
    });

    test('rejects a password without a lowercase letter', () {
      expect(
        RegisterValidators.password('PASSWORD1'),
        'Password must contain at least one lowercase letter',
      );
    });

    test('rejects a password without a number', () {
      expect(
        RegisterValidators.password('Password'),
        'Password must contain at least one number',
      );
    });
  });

  group('RegisterValidators.confirmPassword', () {
    test('accepts matching passwords', () {
      expect(
        RegisterValidators.confirmPassword('Password1', 'Password1'),
        isNull,
      );
    });

    test('rejects null', () {
      expect(
        RegisterValidators.confirmPassword(null, 'Password1'),
        'Please confirm your password',
      );
    });

    test('rejects an empty string', () {
      expect(
        RegisterValidators.confirmPassword('', 'Password1'),
        'Please confirm your password',
      );
    });

    test('rejects mismatched passwords', () {
      expect(
        RegisterValidators.confirmPassword('Password2', 'Password1'),
        'Passwords do not match',
      );
    });
  });

  group('RegisterValidators.phone', () {
    test('accepts a valid phone number', () {
      expect(RegisterValidators.phone('01012345678'), isNull);
    });

    test('accepts a phone number with a leading plus', () {
      expect(RegisterValidators.phone('+201012345678'), isNull);
    });

    test('rejects null', () {
      expect(RegisterValidators.phone(null), 'Please enter your phone number');
    });

    test('rejects an empty string', () {
      expect(RegisterValidators.phone(''), 'Please enter your phone number');
    });

    test('rejects whitespace only', () {
      expect(RegisterValidators.phone('   '), 'Please enter your phone number');
    });

    test('rejects a number that is too short', () {
      expect(
        RegisterValidators.phone('12345'),
        'Please enter a valid phone number',
      );
    });

    test('rejects a number that is too long', () {
      expect(
        RegisterValidators.phone('012345678901234567890'),
        'Please enter a valid phone number',
      );
    });

    test('rejects letters', () {
      expect(
        RegisterValidators.phone('010abc5678'),
        'Please enter a valid phone number',
      );
    });
  });
}