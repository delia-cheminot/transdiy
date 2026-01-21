import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/graph_calculator.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:provider/provider.dart';

class _ChartConstants {
  static const double maxYPadding = 1.15;
  static const double windowWidthFactor = 0.02;
  static const double labelFontSize = 12;
  static const double titleFontSize = 14;
  static const double axesPadding = 8.0;
  static const double bottomReservedSize = 32;
  static const double leftReservedSize = 40;
  static const double lineBarWidth = 3;
  static const double tooltipPadding = 6;
  static const double tooltipRadius = 8;
}

class MainGraph extends StatelessWidget {
  final double window;
  MainGraph({required this.window});

  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final theme = Theme.of(context);

    Map<int, double> daysAndDoses = medicationIntakeProvider.getDaysAndDoses();
    final DateTime firstDay = medicationIntakeProvider.getFirstIntakeDate()!;
    final List<FlSpot> spots = GraphCalculator().generateFlSpots(daysAndDoses);
    final double maxYWithPadding =
        spots.map((s) => s.y).fold(0.0, math.max) * _ChartConstants.maxYPadding;

    String dateLabel(value) {
      final date = firstDay.add(Duration(days: value.toInt()));
      return "${date.day}/${date.month}";
    }

    if (daysAndDoses.isEmpty) return SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            (1 + _ChartConstants.windowWidthFactor * window),
        child: Row(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: _ChartConstants.axesPadding),
              child: RotatedBox(
                quarterTurns: -1,
                child: Text('Concentration (pg/ml)',
                    style: const TextStyle(
                        fontSize: _ChartConstants.titleFontSize)),
              ),
            ),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: (daysAndDoses.keys.last + GraphCalculator.tMaxOffset),
                  minY: 0,
                  maxY: maxYWithPadding,
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: _ChartConstants.bottomReservedSize,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: _ChartConstants.axesPadding),
                            child: Text(dateLabel(value),
                                style: const TextStyle(
                                    fontSize: _ChartConstants.labelFontSize)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: _ChartConstants.leftReservedSize,
                        getTitlesWidget: (value, meta) {
                          return Text(value.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: _ChartConstants.labelFontSize));
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: _ChartConstants.lineBarWidth,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpots) =>
                          theme.colorScheme.tertiaryContainer,
                      tooltipRoundedRadius: _ChartConstants.tooltipRadius,
                      tooltipPadding:
                          const EdgeInsets.all(_ChartConstants.tooltipPadding),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots
                            .map((t) => LineTooltipItem(
                                t.y.toStringAsFixed(1),
                                theme.textTheme.bodySmall?.copyWith(
                                        color: theme
                                            .colorScheme.onTertiaryContainer) ??
                                    const TextStyle()))
                            .toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
