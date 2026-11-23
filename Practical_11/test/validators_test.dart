import 'package:flutter_test/flutter_test.dart';
import 'package:practical11/validators.dart';

void main() {
  test(
    'Required values reject empty and whitespace-only input',
    () {
      for (final value in [null, '', '   ', '\n\t']) {
        expect(requiredValue(value), isNotNull);
      }
      expect(requiredValue(' Валентин '), isNull);
    },
  );
  test('Email accepts ordinary and trimmed addresses', () {
    expect(emailValidator('demo@example.org'), isNull);
    expect(emailValidator(' student+lab@example.edu.ua '), isNull);
  });
  test(
    'Email rejects missing parts, extra at-signs and spaces',
    () {
      for (final value in [
        null,
        '',
        'demo',
        '@a.org',
        'a@',
        'a@b',
        'a@@b.org',
        'a b@example.org',
        'a@b .org',
      ]) {
        expect(emailValidator(value), isNotNull, reason: '$value');
      }
    },
  );
  test('Password boundary is seven characters', () {
    expect(passwordValidator('abcdef'), isNotNull);
    expect(passwordValidator('abcdefg'), isNull);
  });
  test('Password rejects null and whitespace-only values', () {
    expect(passwordValidator(null), isNotNull);
    expect(passwordValidator('       '), isNotNull);
  });
  test('Password counts Unicode code points', () {
    expect(passwordValidator('😀😀😀😀'), isNotNull);
    expect(passwordValidator('😀😀😀😀😀😀😀'), isNull);
  });
  test('Confirmation is required', () {
    expect(confirmationValidator('', 'abcdefg'), isNotNull);
  });
  test('Confirmation must match exactly', () {
    expect(confirmationValidator('abcdefh', 'abcdefg'), isNotNull);
    expect(confirmationValidator('abcdefg', 'abcdefg'), isNull);
  });
}
