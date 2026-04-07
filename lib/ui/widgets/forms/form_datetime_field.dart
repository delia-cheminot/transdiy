import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormDateTimeField extends BaseFormField {
  final DateTime datetime;
  final DateTime? selectedDatetime;
  final ValueChanged<DateTime> onChanged;

// TODO stop requiring onChanged

  FormDateTimeField({
    required this.datetime,
    required this.onChanged,
    this.selectedDatetime,
    required super.label,
    super.errorText,
  });

  @override
  Widget buildField(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: TextEditingController(
                text: datetime.toString().split(' ').first),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
              errorText: errorText,
              suffixIcon: errorText != null
                  ? Icon(Icons.error)
                  : Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
        SizedBox(width: borderPadding),
        IntrinsicWidth(
          child: TextField(
            controller: TextEditingController(
                text: DateFormat('HH:mm').format(datetime)),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              errorText: errorText,
              suffixIcon: errorText != null
                  ? Icon(Icons.error)
                  : Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectTime(context),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDatetime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      picked = DateTime(picked.year, picked.month, picked.day, datetime.hour,
          datetime.minute);
      onChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: datetime.hour, minute: datetime.minute));

    if (picked != null) {
      onChanged(DateTime(datetime.year, datetime.month, datetime.day,
          picked.hour, picked.minute));
    }
  }
}
