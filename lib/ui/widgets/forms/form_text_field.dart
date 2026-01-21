import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormTextField extends BaseFormField {
  final TextEditingController controller;
  final TextInputType inputType;
  final VoidCallback onChanged;
  final bool readonly;

  FormTextField({
    required this.controller,
    required this.inputType,
    required this.onChanged,
    required super.label,
    super.suffixText,
    super.errorText,
    super.regexFormatter,
    this.readonly = false,
  });

  @override
  Widget buildField(BuildContext context) {
    return TextField(
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
    );
  }
}
