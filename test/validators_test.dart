import 'package:flutter_test/flutter_test.dart';
import 'package:email_validator/email_validator.dart';

String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email cannot be empty';
  } else if (!EmailValidator.validate(email)) {
    return 'Invalid email';
  }
  return null;
}

String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Password cannot be empty';
  } else if (password.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  return null;
}

void main() {
  group('Email Validation', () {
    test('Should return error when email is empty', () {
      expect(validateEmail(''), 'Email cannot be empty');
    });

    test('Should return error when email is invalid', () {
      expect(validateEmail('invalid-email'), 'Invalid email');
    });

    test('Should return null when email is valid', () {
      expect(validateEmail('test@example.com'), null);
    });
  });

  group('Password Validation', () {
    test('Should return error when password is empty', () {
      expect(validatePassword(''), 'Password cannot be empty');
    });

    test('Should return error when password is less than 8 characters', () {
      expect(validatePassword('short'), 'Password must be at least 8 characters long');
    });

    test('Should return null when password is valid', () {
      expect(validatePassword('strongpassword123'), null);
    });
  });
}
