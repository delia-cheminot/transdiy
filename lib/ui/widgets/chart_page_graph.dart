import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MainGraph extends StatelessWidget {
  //take the real doses for creation of enanthate graph

  static List<int> _getDays() => [0, 8, 18, 27, 36, 47, 57, 68, 77, 83, 90];
  static List<double> _getDosesMg() => [6, 4, 4, 5.5, 6, 6, 8, 8, 6.4, 4, 6];
  final List<int> days = _getDays();
  final List<double> dosesMg = _getDosesMg();
  final double window;
  final int windowCenter = (_getDays().length / 2).toInt();
  MainGraph({required this.window});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: _getDays().last * 35 + window * 20,
        height: MediaQuery.of(context).size.height - 200,
        child: LineChart(
          LineChartData(
            minX: days[windowCenter].toDouble() - window,
            maxX: days[windowCenter].toDouble() + window,
            minY: 0,
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: true),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: GraphCalculator().generateSpots(dosesMg, days),
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 3,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GraphCalculator {
  double oestradiolEnanthateSingleInjection(double t, int day, double doseMg) {
    if (t <= day || t >= day + 100) return 0.0;

    final coef = <String, double>{
      "D": 333.874181,
      "k1": 0.42412968,
      "k2": 0.43452980,
      "k3": 0.15291485
    };
    final k1 = coef["k1"]!;
    final k2 = coef["k2"]!;
    final k3 = coef["k3"]!;
    final d = coef["D"]!;
    double part1 = math.exp((-t + day) * k1) / ((k1 - k2) * (k1 - k3));
    double part2 = math.exp((-t + day) * k3) / ((k1 - k3) * (k2 - k3));
    double part3 = math.exp((-t + day) * k2) *
        (k3 - k1) /
        ((k1 - k2) * (k1 - k3) * (k2 - k3));
    double point = doseMg * d * 0.2 * k1 * k2 * (part1 + part2 + part3);
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

  List<FlSpot> generateSpots(List<double> doses, List<int> days,
      {double tMin = -10, double tMax = 120, int numPoints = 1000}) {
    List<FlSpot> spots = [];

    for (int i = 0; i <= numPoints; i++) {
      double t = tMin + ((tMax - tMin) / numPoints) * i;
      double concentration = oestradiolEnanthateTotal(t, days, doses);
      spots.add(FlSpot(t, concentration));
    }
    return spots;
  }
}
