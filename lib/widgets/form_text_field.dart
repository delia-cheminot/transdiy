import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? suffixText;
  final String? errorText;
  final TextInputType inputType;
  final VoidCallback onChanged;
  final bool isFirst;
  final String? regexFormatter;

  FormTextField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.suffixText,
    this.errorText,
    required this.inputType,
    this.isFirst = false,
    this.regexFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0 : 8.0, bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        // formatter only if regex is not null
        inputFormatters: regexFormatter != null
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(regexFormatter!)),
              ]
            : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          suffixText: suffixText,
          errorText: errorText,
          suffixIcon: errorText != null ? Icon(Icons.error) : null,
        ),
        onChanged: (value) => onChanged(),
      ),
    );
  }
}
