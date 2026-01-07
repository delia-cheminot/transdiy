import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? suffixText;
  final String? errorText;
  final TextInputType inputType;
  final VoidCallback onChanged;
  final String? regexFormatter;
  final bool readonly;

  FormTextField({
    required this.controller,
    required this.label,
    required this.onChanged,
    this.suffixText,
    this.errorText,
    required this.inputType,
    this.regexFormatter,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: regexFormatter != null
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(regexFormatter!),
                )
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
        readOnly: readonly,
      ),
    );
  }
}
