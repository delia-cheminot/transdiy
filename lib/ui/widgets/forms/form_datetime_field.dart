import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormDateTimeField extends BaseFormField {
  final DateTime datetime;
  final DateTime? selectedDatetime;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;

// TODO stop requiering onChanged

  FormDateTimeField({
    required this.datetime,
    required this.onDateChanged,
    required this.onTimeChanged,
    this.selectedDatetime,
    required super.label,
    super.suffixText,
    super.errorText,
    super.regexFormatter,
  });

  @override
  Widget buildField(BuildContext context) {
    return Row(
      children: <Widget>[
        TextField(
          controller:
              TextEditingController(text: datetime.toString().split(' ').first),
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
            suffixIcon: errorText != null
                ? Icon(Icons.error)
                : Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        TextField(
          controller:
              TextEditingController(text: datetime.toString().split(' ').first),
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
            suffixIcon: errorText != null
                ? Icon(Icons.error)
                : Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectTime(context),
        )
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatetime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: datetime.hour, minute: datetime.minute));

    if (picked != null) {
      onTimeChanged(picked);
    }
  }
}
