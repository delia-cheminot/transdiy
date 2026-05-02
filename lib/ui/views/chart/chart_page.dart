import 'package:flutter/material.dart';
import 'package:mona/data/providers/blood_test_provider.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/ui/views/chart/blood_test_page.dart';
import 'package:mona/ui/views/chart/chart_graph.dart';
import 'package:mona/ui/views/chart/chart_slider.dart';
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 700;

    return Consumer2<MedicationIntakeProvider, BloodTestProvider>(
        builder: (context, medicationIntakeProvider, bloodTestProvider, child) {
      final chart = Column(
        children: [
          ChartSlider(
            value: sliderValue,
            onChanged: (v) => setState(() => sliderValue = v),
          ),
          Expanded(child: MainGraph(window: sliderValue)),
        ],
      );

      final bloodTestList = bloodTestProvider.bloodtestsSortedDesc.isEmpty
          ? null
          : SizedBox(
              width: 300,
              child: BloodTestList(
                bloodtests: bloodTestProvider.bloodtestsSortedDesc,
                onDelete: (test) => bloodTestProvider.deleteBloodTest(test),
              ),
            );

      return MainPageWrapper(
        isLoading: medicationIntakeProvider.isLoading,
        isEmpty: medicationIntakeProvider.graphIntakes.isEmpty,
        emptyMessage: context.l10n.empty_levels,
        child: isDesktop && bloodTestList != null
            ? Row(
                children: [
                  bloodTestList,
                  const VerticalDivider(width: 1),
                  Expanded(child: chart),
                ],
              )
            : chart,
      );
    });
  }
}
