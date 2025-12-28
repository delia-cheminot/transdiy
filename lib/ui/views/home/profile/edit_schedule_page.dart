import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/model/medication_schedule.dart';
import 'package:transdiy/data/providers/medication_schedule_provider.dart';
import 'package:transdiy/ui/widgets/dialogs.dart';
import 'package:transdiy/widgets/form_text_field.dart';

class EditSchedulePage extends StatefulWidget {
  final MedicationSchedule schedule;

  EditSchedulePage({required this.schedule});

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late TextEditingController _intervalDaysController;

  String? get _nameError =>
      MedicationSchedule.validateName(_nameController.text);
  String? get _doseError =>
      MedicationSchedule.validateDose(_doseController.text);
  String? get _intervalDaysError =>
      MedicationSchedule.validateIntervalDays(_intervalDaysController.text);

  bool get _isFormValid =>
      _nameError == null && _doseError == null && _intervalDaysError == null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.schedule.name);
    _doseController =
        TextEditingController(text: widget.schedule.dose.toString());
    _intervalDaysController =
        TextEditingController(text: widget.schedule.intervalDays.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _intervalDaysController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  void _saveSchedule() {
    Decimal? parseDecimal(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return Decimal.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    if (!mounted) return;

    final medicationScheduleProvider =
        Provider.of<MedicationScheduleProvider>(context, listen: false);
    final updatedSchedule = widget.schedule.copyWith(
      name: _nameController.text,
      dose: parseDecimal(_doseController.text)!,
      intervalDays: int.parse(_intervalDaysController.text),
    );
    medicationScheduleProvider.updateSchedule(updatedSchedule);
    Navigator.pop(context, updatedSchedule);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDelete(context);

    if (confirmed == true && mounted) {
      final medicationScheduleProvider =
          Provider.of<MedicationScheduleProvider>(context, listen: false);
      medicationScheduleProvider.deleteSchedule(widget.schedule);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le traitement'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _isFormValid ? _saveSchedule : null,
              child: Text('Sauvegarder'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormTextField(
              controller: _nameController,
              label: 'Nom',
              onChanged: _refresh,
              inputType: TextInputType.text,
              isFirst: true,
              errorText: _nameError,
            ),
            FormTextField(
              controller: _doseController,
              label: 'Dose',
              onChanged: _refresh,
              inputType: TextInputType.number,
              suffixText: 'mg',
              errorText: _doseError,
              regexFormatter: r'[0-9.,]',
            ),
            FormTextField(
              controller: _intervalDaysController,
              label: 'Intervalle',
              suffixText: 'jours',
              onChanged: _refresh,
              inputType: TextInputType.number,
              errorText: _intervalDaysError,
              regexFormatter: r'[0-9]',
            ),
            Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Divider(),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _confirmDelete,
                child: Text('Supprimer'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
