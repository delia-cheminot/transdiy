import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/graph_calculator.dart';
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
    final List<FlSpot> spots = GraphCalculator()
        .generatePoints(doses, days)
        .map((p) => FlSpot(p.x.toDouble(), p.y.toDouble()))
        .toList();
    final double maxConcentration = spots.isEmpty
        ? 0
        : spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    final double maxYWithPadding = maxConcentration * 1.15;

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
                        maxX:
                            (days.last.toDouble() + GraphCalculator.tMaxOffset),
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
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(value.toInt().toString(),
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
                            spots: spots,
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
