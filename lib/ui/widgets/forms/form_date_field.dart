import 'package:flutter/material.dart';
import 'package:mona/data/model/date.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormDateField extends BaseFormField {
  final Date date;
  final Date? selectedDate;
  final ValueChanged<Date> onChanged;

  FormDateField({
    required this.date,
    required this.onChanged,
    this.selectedDate,
    required super.label,
    super.errorText,
  });

  @override
  Widget buildField(BuildContext context) {
    return TextField(
      controller:
          TextEditingController(text: '${date.year}-${date.month}-${date.day}'),
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        errorText: errorText,
        suffixIcon:
            errorText != null ? Icon(Icons.error) : Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (selectedDate ?? date).toDateTime(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onChanged(Date(picked.toUtc()));
    }
  }
}
