import 'package:flutter/material.dart';
import 'package:mona/util/validators.dart';

class FormDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final bool required;

  const FormDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.required,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 6),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items,
        onChanged: onChanged,
        validator: required ? requiredValue : null,
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
