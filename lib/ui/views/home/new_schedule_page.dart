import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class NewSchedulePage extends StatefulWidget {
  @override
  State<NewSchedulePage> createState() => _NewSchedulePageState();
}

class _NewSchedulePageState extends State<NewSchedulePage> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late TextEditingController _intervalDaysController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _doseController = TextEditingController();
    _intervalDaysController = TextEditingController();
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
    medicationScheduleProvider.addSchedule(name, dose, intervalDays);
    Navigator.pop(context);
  }

  String? get _nameError =>
      MedicationSchedule.validateName(_nameController.text);
  String? get _doseError =>
      MedicationSchedule.validateDose(_doseController.text);
  String? get _intervalDaysError =>
      MedicationSchedule.validateIntervalDays(_intervalDaysController.text);

  bool get _isFormValid =>
      _nameError == null && _doseError == null && _intervalDaysError == null;

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nouveau traitement'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 1.0),
              child: TextButton(
                onPressed: _isFormValid ? _addSchedule : null,
                child: Text('Ajouter'),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FormTextField(
                  controller: _nameController,
                  label: 'Nom',
                  onChanged: _refresh,
                  inputType: TextInputType.text,
                  isFirst: true,
                ),
                FormTextField(
                  controller: _doseController,
                  label: 'Dose',
                  suffixText: 'mg',
                  onChanged: _refresh,
                  inputType: TextInputType.numberWithOptions(decimal: false),
                  regexFormatter: '[0-9]',
                ),
                FormTextField(
                  controller: _intervalDaysController,
                  label: 'Tous les',
                  suffixText: 'jours',
                  onChanged: _refresh,
                  inputType: TextInputType.numberWithOptions(decimal: false),
                  regexFormatter: '[0-9]',
                ),
              ],
            ),
          ),
        ));
  }
}
