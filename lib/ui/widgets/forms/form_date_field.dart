import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormDateField extends BaseFormField {
  final DateTime date;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChanged;

  FormDateField({
    required this.date,
    required this.onChanged,
    this.selectedDate,
    required super.label,
    super.suffixText,
    super.errorText,
    super.regexFormatter,
  });

  @override
  Widget buildField(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: date.toString().split(' ').first),
      keyboardType: TextInputType.datetime,
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
        suffixIcon: errorText != null ? Icon(Icons.error) : Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
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
