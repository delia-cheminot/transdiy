

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/data/model/blood_test.dart';
import 'package:mona/data/providers/blood_test_provider.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/decimal_helpers.dart';
import 'package:provider/provider.dart';


class NewBloodTestPage extends StatefulWidget {
  @override
  State<NewBloodTestPage> createState() => _NewBloodTestPageState();
}

class _NewBloodTestPageState extends State<NewBloodTestPage> {
  late TextEditingController _estradiolLevelsController;
  late TextEditingController _testosteroneLevelsController;
  late DateTime _testDate;

  String? get _testDateError =>
      BloodTest.validateDate(_testDate);

  bool get _isFormValid =>
      _testDateError == null;

  Decimal? _parseOptionalDecimal(String decimalString) {
    final decimal = decimalString.trim();
    if (decimal.isEmpty) return null;
    return parseDecimal(decimal);
  }

  void _refresh() {
    setState(() {});
  }


  void _addBloodTest() {
    final estradiolLevels =
        _parseOptionalDecimal(_estradiolLevelsController.text);
    final testosteroneLevels =
        _parseOptionalDecimal(_testosteroneLevelsController.text);
    final bloodTestProvider =
        Provider.of<BloodTestProvider>(context, listen: false);

    final bloodtest = BloodTest(
      date: _testDate,
      estradiolLevels: estradiolLevels,
      testosteroneLevels: testosteroneLevels,
    );
    bloodTestProvider.add(bloodtest);

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _estradiolLevelsController = TextEditingController();
    _testosteroneLevelsController = TextEditingController();
    _testDate = DateTime.now();
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
          label: 'Estradiol levels',
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
        ),
        FormSpacer(),
        FormTextField(
          controller: _testosteroneLevelsController,
          label: 'Testosterone levels',
          onChanged: _refresh,
          inputType: TextInputType.numberWithOptions(decimal: true),
          regexFormatter: '[0-9.,]',
        ),
        FormSpacer(),
        FormDateField(
          date: _testDate,
          label: 'Test date',
          errorText: _testDateError,
          onChanged: (date) => setState(() {
            _testDate = date;
          }),
        ),
      ],
    );
  }
}