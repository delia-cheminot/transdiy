import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/graph_calculator.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:provider/provider.dart';

class MainPageOestradiol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final DateTime firstDay = medicationIntakeProvider.getFirstIntakeDate()!;
    final todayX = DateTime.now().difference(firstDay).inDays.toDouble();
    Map<int, double> daysAndDoses = medicationIntakeProvider.getDaysAndDoses();
    final List<FlSpot> spots = GraphCalculator().generateFlSpots(daysAndDoses);
    final todaySpot = spots.reduce(
      (a, b) => (a.x - todayX).abs() < (b.x - todayX).abs() ? a : b,
    );

    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
         ListTile(
          leading: Icon(Icons.trending_up_sharp),
          title: Text('Your oestrogen levels today are estimated to be ${ todaySpot.y.toStringAsFixed(1)} pg/ml'),
        ),
      ]),
    );
  }
}
