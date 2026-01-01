import 'package:flutter/material.dart';
import 'package:transdiy/ui/widgets/chart_page_graph.dart';
import 'package:transdiy/ui/widgets/chart_page_slider.dart';


class ChartPage extends StatefulWidget {
  @override 
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChartSlider(
          value: sliderValue,
          onChanged: (newValue) {
            setState(() => sliderValue = newValue);
            
          },
        ),
        MainGraph(window: sliderValue),
      ]
    );
  }
}
