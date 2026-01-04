import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/widgets/chart_page_graph.dart';
import 'package:mona/ui/widgets/chart_page_slider.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    final medicationIntakeProvider = context.watch<MedicationIntakeProvider>();
    final int intakeCount = medicationIntakeProvider.intakes.length;

    if (intakeCount == 0) {
      return Center(
        child: Text('take your pills alice'),
      );
    }

    return Column(children: [
      ChartSlider(
        value: sliderValue,
        onChanged: (newValue) {
          setState(() => sliderValue = newValue);
        },
      ),
      MainGraph(window: sliderValue),
    ]);
  }
}
