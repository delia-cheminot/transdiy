import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/ui/widgets/chart_page_graph.dart';
import 'package:mona/ui/widgets/chart_page_slider.dart';
import 'package:mona/ui/widgets/main_page_wrapper.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationIntakeProvider>(
      builder: (context, medicationIntakeProvider, child) {
        return MainPageWrapper(
          isLoading: medicationIntakeProvider.isLoading,
          isEmpty: medicationIntakeProvider.takenIntakes.isEmpty,
          emptyMessage: 'take your pills alice',
          child: Column(
            children: [
              ChartSlider(
                value: sliderValue,
                onChanged: (v) => setState(() => sliderValue = v),
              ),
              MainGraph(window: sliderValue),
            ],
          ),
        );
      }
    );
  }
}
