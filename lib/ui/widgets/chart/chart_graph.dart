import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:provider/provider.dart';

class MainGraph extends StatelessWidget {
  // take the real doses for creation of enanthate graph

  final double window;
  MainGraph({required this.window});

  @override
  Widget build(BuildContext context) {
    Map<int, double> daysAndDoses =
        context.watch<MedicationIntakeProvider>().getDaysAndDoses();
    final List<int> days = daysAndDoses.keys.toList();
    final List<double> doses = daysAndDoses.values.toList();

    // padding on the top for accessibility
    List<FlSpot> spots = GraphCalculator().generateSpots(doses, days);
    double maxConcentration = spots.isEmpty
        ? 0
        : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    double maxYWithPadding = maxConcentration * 1.15;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 4 * MediaQuery.of(context).size.width -
            2 * MediaQuery.of(context).size.width * 0.01 * (100 - window),
        height: 3 * MediaQuery.of(context).size.height / 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text('Concentration (pg/ml)',
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: (days.last.toDouble() + 40),
                        minY: 0,
                        maxY: maxYWithPadding,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                final txt = value.toInt().toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(txt,
                                      style: const TextStyle(fontSize: 12)),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toStringAsFixed(1),
                                    style: const TextStyle(fontSize: 12));
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: GraphCalculator().generateSpots(doses, days),
                            isCurved: true,
                            color: Theme.of(context).colorScheme.primary,
                            barWidth: 3,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
              child: Center(
                  child: Text('Days', style: const TextStyle(fontSize: 14))),
            ),
          ],
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
      {double tMin = 0, double tMax = 120, int numPoints = 1000}) {
    List<FlSpot> spots = [];
    tMax = days.last.toDouble() + 40;

    for (int i = 0; i <= numPoints; i++) {
      double t = tMin + ((tMax - tMin) / numPoints) * i;
      double concentration = oestradiolEnanthateTotal(t, days, doses);
      spots.add(FlSpot(t, concentration));
    }
    return spots;
  }
}
