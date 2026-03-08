import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:mona/data/model/ester.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';

class GraphCalculator {
  static const double tMaxOffset = 40.0;
  static const double _inactiveWindow = 100.0;
  static const double _dFactor = 0.2;
  static final Map<Ester, Map<String, double>> _coefs = {
    Ester.enanthate: {
      "D": 333.874181,
      "k1": 0.42412968,
      "k2": 0.43452980,
      "k3": 0.15291485,
    },
    Ester.valerate: {
      "D": 2596.05956,
      "k1": 2.38229125,
      "k2": 0.23345814,
      "k3": 1.37642769,
    },
    Ester.benzoate: {
      "D": 1.7050e+08,
      "k1": 3.22397192,
      "k2": 0.58870148,
      "k3": 70721.4018,
    },
    Ester.cypionate: {
      "D": 1920.89671,
      "k1": 0.10321089,
      "k2": 0.89854779,
      "k3": 0.89359759,
    },
    Ester.cypionateSuspension: {
      "D": 1.5669e+08,
      "k1": 0.13586726,
      "k2": 2.51772731,
      "k3": 74768.1493,
    },
    Ester.undecylate: {
      "D": 65.9493374,
      "k1": 0.29634323,
      "k2": 4799337.57,
      "k3": 0.03141554,
    },
    Ester.polyPhosphate: {
      "D": 34.46836875,
      "k1": 0.02456035,
      "k2": 135643.711,
      "k3": 0.10582368,
    },
  };

  Map<String, double> getCoef(GraphIntake intake) {
    return _coefs[intake.ester] ?? _coefs[Ester.enanthate]!;
  }

  double _singleInjectionConcentration(double t, int day, GraphIntake intake) {
    if (t <= day || t >= day + _inactiveWindow) return 0.0;

    Map<String, double> coef = getCoef(intake);

    final k1 = coef["k1"]!;
    final k2 = coef["k2"]!;
    final k3 = coef["k3"]!;
    final d = coef["D"]!;

    double part1 = math.exp((-t + day) * k1) / ((k1 - k2) * (k1 - k3));
    double part2 = math.exp((-t + day) * k3) / ((k1 - k3) * (k2 - k3));
    double part3 = math.exp((-t + day) * k2) *
        (k3 - k1) /
        ((k1 - k2) * (k1 - k3) * (k2 - k3));

    double concentration =
        intake.dose * d * _dFactor * k1 * k2 * (part1 + part2 + part3);
    return concentration;
  }

  double _totalConcentrationAtTime(
      double t, Map<int, GraphIntake> daysAndIntakes) {
    if (daysAndIntakes.isEmpty) return 0.0;
    return daysAndIntakes.entries
        .map((e) => _singleInjectionConcentration(t, e.key, e.value))
        .fold(0.0, (sum, val) => sum + val);
  }

  List<FlSpot> generateFlSpots(Map<int, GraphIntake> daysAndIntakes,
      {double tMin = 0, int numPoints = 1000}) {
    if (daysAndIntakes.isEmpty) return <FlSpot>[];

    final int maxDay = daysAndIntakes.keys.reduce(math.max);
    final double tMax = maxDay.toDouble() + tMaxOffset;
    final List<math.Point> points = [];

    for (int i = 0; i <= numPoints; i++) {
      double t = tMin + ((tMax - tMin) / numPoints) * i;
      double concentration = _totalConcentrationAtTime(t, daysAndIntakes);
      points.add(math.Point(t, concentration));
    }

    return points.map((p) => FlSpot(p.x.toDouble(), p.y.toDouble())).toList();
  }
}
