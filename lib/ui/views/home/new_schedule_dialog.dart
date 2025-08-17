import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';

class NewScheduleDialog extends StatefulWidget {
  @override
  State<NewScheduleDialog> createState() => _NewScheduleDialogState();
}

class _NewScheduleDialogState extends State<NewScheduleDialog> {
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
    final dose = double.parse(_doseController.text);
    final intervalDays = int.parse(_intervalDaysController.text);
    final medicationScheduleState =
        Provider.of<MedicationScheduleProvider>(context, listen: false);
    medicationScheduleState.addSchedule(name, dose, intervalDays);
    Navigator.pop(context);
  }

  bool _validateInputs() {
    if (!_isNameValid()) {
      setState(() {});
      return false;
    }
    if (!_isDoseValid()) {
      setState(() {});
      return false;
    }
    if (!_isIntervalDaysValid()) {
      setState(() {});
      return false;
    }
    setState(() {});
    return true;
  }

  bool _isNameValid() {
    return _nameController.text.isNotEmpty;
  }

  bool _isDoseValid() {
    final dose = double.tryParse(_doseController.text);
    return dose != null && dose > 0;
  }

  bool _isIntervalDaysValid() {
    final intervalDays = int.tryParse(_intervalDaysController.text);
    return intervalDays != null && intervalDays > 0;
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
              onPressed: _validateInputs() ? _addSchedule : null,
              child: Text('Ajouter'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                ),
                onChanged: (value) => _validateInputs(),
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: _doseController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dose',
                  suffixText: 'mg',
                ),
                onChanged: (value) => _validateInputs(),
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: TextField(
                controller: _intervalDaysController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Tous les',
                  suffixText: 'jours',
                ),
                onChanged: (value) => _validateInputs(),
              ),
            ),
          ],
        ),
      )
    );
  }
}
