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

  double oestradiolEnanthateSingleInjection(double t, int day, double doseMg) {
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

    double point = doseMg * d * _dFactor * k1 * k2 * (part1 + part2 + part3);
    return point;
  }

  double oestradiolEnanthateTotal(
      double t, List<int> days, List<double> dosesMg) {
    double total = 0;
    for (int i = 0; days.length > i; i++) {
      total += oestradiolEnanthateSingleInjection(t, days[i], dosesMg[i]);
    }
    return total;
  }

  List<FlSpot> generateFlSpots(List<double> doses, List<int> days,
      {double tMin = 0, double tMax = 120, int numPoints = 1000}) {
    final List<math.Point> points = [];
    tMax = days.last.toDouble() + tMaxOffset;

    for (int i = 0; i <= numPoints; i++) {
      double t = tMin + ((tMax - tMin) / numPoints) * i;
      double concentration = oestradiolEnanthateTotal(t, days, doses);
      points.add(math.Point(t, concentration));
    }
    return points.map((p) => FlSpot(p.x.toDouble(), p.y.toDouble())).toList();
  }
}
