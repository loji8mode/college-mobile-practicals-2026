class Calc {
  double f(double x) {
    if (!x.isFinite || x == 0) throw ArgumentError.value(x, 'x');
    final value = x - 1 / (x * x) + 1 / (x * x * x);
    if (!value.isFinite) throw RangeError('Result is outside double range');
    return value;
  }
}
