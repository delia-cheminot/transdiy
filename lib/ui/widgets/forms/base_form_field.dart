import 'package:flutter/material.dart';

abstract class BaseFormField extends StatelessWidget {
  final String label;
  final String? suffixText;
  final String? errorText;
  final String? regexFormatter;

  const BaseFormField({
    required this.label,
    this.suffixText,
    this.errorText,
    this.regexFormatter,
  });

  Widget buildField(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: buildField(context),
    );
  }
}
