import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormDateField extends StatelessWidget {
  final DateTime date;
  final String label;
  final String? suffixText;
  final String? errorText;
  final String? regexFormatter;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  FormDateField({
    required this.date,
    required this.label,
    this.suffixText,
    this.errorText,
    this.regexFormatter,
    this.selectedDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: TextField(
        controller: TextEditingController(
                  text: date.toString().split(' ').first),
        keyboardType: TextInputType.datetime,
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
          suffixIcon: errorText != null
              ? Icon(Icons.error)
              : Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () => _selectDate(context)
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}
