import 'package:flutter/material.dart';

class FormSpacer extends StatelessWidget {
  final double height;

  const FormSpacer({this.height = 16, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
