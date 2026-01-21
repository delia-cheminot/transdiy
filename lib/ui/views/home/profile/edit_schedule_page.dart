import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/medication_schedule.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:provider/provider.dart';

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
  late DateTime _startDate;
  late MedicationScheduleProvider _medicationScheduleProvider;

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

  @override
  void initState() {
    super.initState();
    _medicationScheduleProvider =
        Provider.of<MedicationScheduleProvider>(context, listen: false);
    _nameController = TextEditingController(text: widget.schedule.name);
    _doseController =
        TextEditingController(text: widget.schedule.dose.toString());
    _intervalDaysController =
        TextEditingController(text: widget.schedule.intervalDays.toString());
    _startDate = widget.schedule.startDate;
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

    final updatedSchedule = widget.schedule.copyWith(
      name: _nameController.text,
      dose: parseDecimal(_doseController.text)!,
      intervalDays: int.parse(_intervalDaysController.text),
      startDate: _startDate,
    );
    _medicationScheduleProvider.updateSchedule(updatedSchedule);
    Navigator.pop(context, updatedSchedule);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDelete(context);

    if (confirmed == true && mounted) {
      _medicationScheduleProvider.deleteSchedule(widget.schedule);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModelForm(
      title: 'Edit schedule',
      submitButtonLabel: 'Save',
      isFormValid: _isFormValid,
      saveChanges: _saveSchedule,
      onDelete: _confirmDelete,
      fields: [
        FormTextField(
          controller: _nameController,
          label: 'Name',
          onChanged: _refresh,
          inputType: TextInputType.text,
          errorText: _nameError,
        ),
        FormTextField(
          controller: _doseController,
          label: 'Amount',
          onChanged: _refresh,
          inputType: TextInputType.number,
          suffixText: 'mg',
          errorText: _doseError,
          regexFormatter: r'[0-9.,]',
        ),
        FormTextField(
          controller: _intervalDaysController,
          label: 'Time interval',
          suffixText: 'days',
          onChanged: _refresh,
          inputType: TextInputType.number,
          errorText: _intervalDaysError,
          regexFormatter: r'[0-9]',
        ),
        FormDateField(
          date: _startDate,
          label: 'Start date',
          errorText: _startDateError,
          onChanged: (date) => setState(() {
            _startDate = date;
          }),
        ),
      ],
    );
  }
}
