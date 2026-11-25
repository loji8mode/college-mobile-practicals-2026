import 'package:flutter_test/flutter_test.dart';
import 'package:practical15/calc.dart';

void main() {
  final calc = Calc();
  final cases = <double, double>{1: 1, 2: 1.875, -1: -3, -2: -2.375, 0.5: 4.5};
  for (final entry in cases.entries) {
    test('Known function value at x = ${entry.key}', () {
      expect(calc.f(entry.key), closeTo(entry.value, 1e-12));
    });
  }
  test('Zero and nonfinite arguments are rejected', () {
    for (final x in [
      0.0,
      -0.0,
      double.nan,
      double.infinity,
      double.negativeInfinity,
    ]) {
      expect(() => calc.f(x), throwsArgumentError);
    }
  });
  test('Unrepresentable result is rejected', () {
    expect(() => calc.f(1e-200), throwsRangeError);
  });
}
