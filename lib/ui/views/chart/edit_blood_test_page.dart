import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mona/data/model/blood_test.dart';
import 'package:mona/data/providers/blood_test_provider.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class EditBloodTestPage extends StatefulWidget {
  final BloodTest bloodtest;
  EditBloodTestPage({required this.bloodtest});

  @override
  State<EditBloodTestPage> createState() => _EditBloodTestPageState();
}

class _EditBloodTestPageState extends State<EditBloodTestPage> {
  late TextEditingController _estradiolLevelsController;
  late TextEditingController _testosteroneLevelsController;
  late DateTime _testDateTime;
  late BloodTestProvider _bloodTestProvider;
  bool _dateTimeChanged = false;

  String? get _testDateError => BloodTest.validateDate(_testDateTime);
  String? get _estradiolLevelsError =>
      BloodTest.validateLevel(_estradiolLevelsController.text);
  String? get _testosteroneLevelsError =>
      BloodTest.validateLevel(_testosteroneLevelsController.text);

  bool get _isFormValid => _testDateError == null;

  void _refresh() {
    setState(() {});
  }

  Future<void> _confirmDelete() async {
    final confirmed = await Dialogs.confirmDeleteDialog(context: context);

    if (confirmed == true && mounted) {
      _bloodTestProvider.deleteBloodTest(widget.bloodtest);
      Navigator.pop(context);
    }
  }

  void _saveBloodTest() async {
    if (!_isFormValid) return;
    if (!mounted) return;

    final timezone =
        _dateTimeChanged ? await FlutterTimezone.getLocalTimezone() : null;

    final updatedBloodTest = widget.bloodtest.copyWith(
      dateTime: _testDateTime,
      timeZone: timezone?.identifier,
      estradiolLevels: _estradiolLevelsController.text.toDecimalOrNull,
      testosteroneLevels: _testosteroneLevelsController.text.toDecimalOrNull,
    );
    await _bloodTestProvider.updateBloodTest(updatedBloodTest);

    if (!mounted) return;
    Navigator.pop(context, updatedBloodTest);
  }

  @override
  void initState() {
    super.initState();
    _bloodTestProvider = Provider.of<BloodTestProvider>(context, listen: false);
    _estradiolLevelsController = TextEditingController(
        text: widget.bloodtest.estradiolLevels?.toString());
    _testosteroneLevelsController = TextEditingController(
        text: widget.bloodtest.testosteroneLevels?.toString());
    _testDateTime = widget.bloodtest.dateTime;
  }

  @override
  void dispose() {
    _estradiolLevelsController.dispose();
    _testosteroneLevelsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModelForm(
      title: 'Edit blood test',
      submitButtonLabel: 'Save',
      isFormValid: _isFormValid,
      saveChanges: _saveBloodTest,
      onDelete: _confirmDelete,
      fields: <Widget>[
        FormTextField(
          controller: _estradiolLevelsController,
          label: 'Estradiol level',
          errorText: _estradiolLevelsError,
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
        ),
        FormSpacer(),
        FormTextField(
          controller: _testosteroneLevelsController,
          label: 'Testosterone level',
          errorText: _testosteroneLevelsError,
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
        ),
        FormSpacer(),
        FormDateField(
          date: _testDateTime,
          label: 'Test date',
          errorText: _testDateError,
          onChanged: (date) => setState(() {
            _testDateTime = date;
            _dateTimeChanged = true;
          }),
        ),
      ],
    );
  }
}
