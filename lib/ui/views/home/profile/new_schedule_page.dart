import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/widgets/form_date_field.dart';
import 'package:mona/widgets/form_text_field.dart';
import 'package:provider/provider.dart';

class NewSchedulePage extends StatefulWidget {
  @override
  State<NewSchedulePage> createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late TextEditingController _intervalDaysController;
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _doseController = TextEditingController();
    _intervalDaysController = TextEditingController();
    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _intervalDaysController.dispose();
    super.dispose();
  }

  void _addSchedule() {
    final name = _nameController.text;
    final dose = Decimal.parse(_doseController.text);
    final intervalDays = int.parse(_intervalDaysController.text);
    final medicationScheduleProvider =
        Provider.of<MedicationScheduleProvider>(context, listen: false);
    medicationScheduleProvider.addSchedule(name, dose, intervalDays,
        startDate: _startDate);
    Navigator.pop(context);
  }

  String? get _nameError =>
      MedicationSchedule.validateName(_nameController.text);
  String? get _doseError =>
      MedicationSchedule.validateDose(_doseController.text);
  String? get _intervalDaysError =>
      MedicationSchedule.validateIntervalDays(_intervalDaysController.text);
  String? get _startDateError =>
      MedicationSchedule.validateStartDate(_startDate);

  bool get _isFormValid =>
      _nameError == null &&
      _doseError == null &&
      _intervalDaysError == null &&
      _startDateError == null;

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New schhedule'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 1.0),
              child: TextButton(
                onPressed: _isFormValid ? _addSchedule : null,
                child: Text('Add'),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FormTextField(
                    controller: _nameController,
                    label: 'Name',
                    onChanged: _refresh,
                    inputType: TextInputType.text,
                  ),
                  FormTextField(
                    controller: _doseController,
                    label: 'Amount',
                    suffixText: 'mg',
                    onChanged: _refresh,
                    inputType: TextInputType.number,
                    regexFormatter: '[0-9.,]',
                  ),
                  FormTextField(
                    controller: _intervalDaysController,
                    label: 'Time interval',
                    suffixText: 'days',
                    onChanged: _refresh,
                    inputType: TextInputType.numberWithOptions(decimal: false),
                    regexFormatter: '[0-9]',
                  ),
                  FormDateField(
                    date: _startDate,
                    label: 'Start date',
                    errorText: _startDateError,
                    onChanged: (date) => setState(() {
                      _startDate = date;
                    }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
