import 'dart:math' as math;

extension DoubleRoundExtension on double {
  double roundTo(int places) {
    double mod = math.pow(10.0, places).toDouble();
    return ((this * mod).round().toDouble() / mod);
  }
}
