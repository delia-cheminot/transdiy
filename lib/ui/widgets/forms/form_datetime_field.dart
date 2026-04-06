import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mona/ui/widgets/forms/base_form_field.dart';

class FormDateTimeField extends BaseFormField {
  final DateTime datetime;
  final DateTime? selectedDatetime;
  final ValueChanged<DateTime> onDateTimeChanged;

// TODO stop requiering onChanged

  FormDateTimeField({
    required this.datetime,
    required this.onDateTimeChanged,
    this.selectedDatetime,
    required super.label,
    super.errorText,
    super.regexFormatter,
  });

  @override
  Widget buildField(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: TextEditingController(
                text: datetime.toString().split(' ').first),
            keyboardType: TextInputType.datetime,
            inputFormatters: regexFormatter != null
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(regexFormatter!)),
                  ]
                : null,
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
        SizedBox(width: 8),
        IntrinsicWidth(
          child: TextField(
            controller: TextEditingController(
                text: DateFormat('HH:mm').format(datetime)),
            inputFormatters: regexFormatter != null
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(regexFormatter!)),
                  ]
                : null,
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
      picked = DateTime(picked.year, picked.month, picked.day, datetime.hour, datetime.minute);
      onDateTimeChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: datetime.hour, minute: datetime.minute));

    if (picked != null) {
      onDateTimeChanged(DateTime(datetime.year,datetime.month, datetime.day, picked.hour, picked.minute));
    }
  }
}
