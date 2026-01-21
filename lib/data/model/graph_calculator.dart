import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';

class GraphCalculator {
  static const double tMaxOffset = 40.0;
  static const double _inactiveWindow = 100.0;
  static const double _dFactor = 0.2;
  static const Map<String, double> _coef = {
    "D": 333.874181,
    "k1": 0.42412968,
    "k2": 0.43452980,
    "k3": 0.15291485
  };

  // een for now
  double singleInjectionConcentration(double t, int day, double doseMg) {
    if (t <= day || t >= day + _inactiveWindow) return 0.0;

    final k1 = _coef["k1"]!;
    final k2 = _coef["k2"]!;
    final k3 = _coef["k3"]!;
    final d = _coef["D"]!;

    double part1 = math.exp((-t + day) * k1) / ((k1 - k2) * (k1 - k3));
    double part2 = math.exp((-t + day) * k3) / ((k1 - k3) * (k2 - k3));
    double part3 = math.exp((-t + day) * k2) *
        (k3 - k1) /
        ((k1 - k2) * (k1 - k3) * (k2 - k3));

    double concentration =
        doseMg * d * _dFactor * k1 * k2 * (part1 + part2 + part3);
    return concentration;
  }

  double totalConcentrationAtTime(double t, Map<int, double> daysAndDoses) {
    if (daysAndDoses.isEmpty) return 0.0;
    return daysAndDoses.entries
        .map((e) => singleInjectionConcentration(t, e.key, e.value))
        .fold(0.0, (sum, val) => sum + val);
  }

  List<FlSpot> generateFlSpots(Map<int, double> daysAndDoses,
      {double tMin = 0, double tMax = 120, int numPoints = 1000}) {
    final List<math.Point> points = [];
    if (daysAndDoses.isEmpty) return <FlSpot>[];
    final int maxDay = daysAndDoses.keys.reduce(math.max);
    tMax = maxDay.toDouble() + tMaxOffset;

    for (int i = 0; i <= numPoints; i++) {
      double t = tMin + ((tMax - tMin) / numPoints) * i;
      double concentration = totalConcentrationAtTime(t, daysAndDoses);
      points.add(math.Point(t, concentration));
    }
    return points.map((p) => FlSpot(p.x.toDouble(), p.y.toDouble())).toList();
  }
}
