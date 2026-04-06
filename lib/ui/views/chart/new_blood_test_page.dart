import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mona/data/model/blood_test.dart';
import 'package:mona/data/providers/blood_test_provider.dart';
import 'package:mona/ui/widgets/forms/form_datetime_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class NewBloodTestPage extends StatefulWidget {
  @override
  State<NewBloodTestPage> createState() => _NewBloodTestPageState();
}

class _NewBloodTestPageState extends State<NewBloodTestPage> {
  late TextEditingController _estradiolLevelsController;
  late TextEditingController _testosteroneLevelsController;
  late DateTime _testDateTime;

  String? get _testDateError => BloodTest.validateDate(_testDateTime);
  String? get _estradiolError =>
      BloodTest.validateLevel(_estradiolLevelsController.text);
  String? get _testosteroneError =>
      BloodTest.validateLevel(_testosteroneLevelsController.text);

  bool get _isFormValid =>
      _testDateError == null &&
      _estradiolError == null &&
      _testosteroneError == null;

  void _refresh() {
    setState(() {});
  }

  void _addBloodTest() async {
    final bloodTestProvider =
        Provider.of<BloodTestProvider>(context, listen: false);
    final estradiolLevels = _estradiolLevelsController.text.toDecimalOrNull;
    final testosteroneLevels =
        _testosteroneLevelsController.text.toDecimalOrNull;
    final timezone = await FlutterTimezone.getLocalTimezone();
    final tzName = timezone.identifier;

    final bloodtest = BloodTest(
      dateTime: _testDateTime.toUtc(),
      timeZone: tzName,
      estradiolLevels: estradiolLevels,
      testosteroneLevels: testosteroneLevels,
    );
    await bloodTestProvider.add(bloodtest);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _estradiolLevelsController = TextEditingController();
    _testosteroneLevelsController = TextEditingController();
    _testDateTime = DateTime.now();
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
      title: 'New blood test',
      submitButtonLabel: 'Add',
      isFormValid: _isFormValid,
      saveChanges: _addBloodTest,
      fields: <Widget>[
        FormTextField(
          controller: _estradiolLevelsController,
          label: 'Estradiol level',
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
          errorText: _estradiolError,
          suffixText: 'pg/ml',
        ),
        FormTextField(
          controller: _testosteroneLevelsController,
          label: 'Testosterone level',
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
          errorText: _testDateError,
          suffixText: 'ng/dL', // TODO check si units
        ),
        FormSpacer(),
        FormDateTimeField(
          datetime: _testDateTime,
          label: 'Test date',
          errorText: _testDateError,
          onChanged: (date) => setState(() {
            _testDateTime = date;
          }),
          // TODO create a method onDateChanged
        ),
      ],
    );
  }
}
