import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mona/controllers/medication_intake_manager.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/l10n/helpers/supply_item_l10n.dart';
import 'package:mona/ui/views/intakes/intakes_page.dart';
import 'package:mona/ui/widgets/dropdowns/injection_side_dropdown.dart';
import 'package:mona/ui/widgets/forms/form_datetime_field.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_info_text.dart';
import 'package:mona/ui/widgets/forms/form_spacer.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:mona/ui/widgets/forms/model_form.dart';
import 'package:mona/util/string_parsing.dart';
import 'package:provider/provider.dart';

class EditIntakePage extends StatefulWidget {
  final MedicationIntake intake;

  EditIntakePage(this.intake);

  @override
  State<EditIntakePage> createState() => _EditIntakePageState();
}

class _EditIntakePageState extends State<EditIntakePage> {
  late DateTime _takenDate;
  bool _takenDateChanged = false;
  late TextEditingController _takenDoseController;
  late Decimal _takenDose;
  InjectionSide? _selectedSide;
  bool _hasInitializedSide = false;
  SupplyItem? _selectedSupplyItem;
  bool _hasInitializedSupplyItem = false;

  String? get _takenDoseError =>
      MedicationIntake.validateDose(context.l10n, _takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null;

  bool get _isInjection =>
      widget.intake.administrationRoute == AdministrationRoute.injection;

  void _editIntake(
      MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider,
      MedicationIntake intake,
      SupplyItem? newItem) async {
    if (!_isFormValid) return;
    if (!mounted) return;

    SupplyItem? previousItem =
        supplyItemProvider.getItemById(intake.supplyItemId);

    SupplyItemManager(supplyItemProvider)
        .switchDoses(previousItem, newItem, intake.dose, _takenDose);

    final timezone =
        _takenDateChanged ? await FlutterTimezone.getLocalTimezone() : null;

    MedicationIntake updatedIntake = intake.copyWith(
      takenDateTime: _takenDate.toUtc(),
      dose: _takenDose,
      side: _selectedSide,
      takenTimeZone: timezone?.identifier,
      supplyItemId: newItem?.id,
    );

    medicationIntakeProvider.updateIntake(updatedIntake);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _deleteIntake(MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider, MedicationIntake intake) async {
    if (!mounted) return;
    MedicationIntakeManager(medicationIntakeProvider, supplyItemProvider)
        .deleteIntake(intake);
    Navigator.of(context).pop();
  }

  void _onInjectionSideChanged(InjectionSide? side) {
    if (side != null) {
      setState(() {
        _selectedSide = side;
      });
    }
  }

  void _onTakenDateChanged(DateTime date) {
    setState(() {
      _takenDate = date;
      _takenDateChanged = true;
    });
  }

  void _onTakenDoseChanged() {
    final dose = _takenDoseController.text.toDecimalOrNull;

    if (dose != null) {
      setState(() {
        _takenDose = dose;
      });
    }
  }

  void _onSupplyItemChanged(SupplyItem? item) {
    setState(() {
      _selectedSupplyItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    _takenDate = widget.intake.takenDateTime?.toLocal() ?? DateTime.now();
    print(_takenDate);
    _takenDose = widget.intake.dose;
    _takenDoseController =
        TextEditingController(text: widget.intake.dose.toString());
  }

  @override
  void dispose() {
    _takenDoseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {
        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading && !_hasInitializedSide && _isInjection) {
          _selectedSide = widget.intake.side;
          _hasInitializedSide = true;
        }

        if (!isLoading && !_hasInitializedSupplyItem) {
          _selectedSupplyItem =
              supplyItemProvider.getItemById(widget.intake.supplyItemId);
          _hasInitializedSupplyItem = true;
        }

        final supplyItemOptions = supplyItemProvider.getItemsForMedication(
          widget.intake.molecule,
          widget.intake.administrationRoute,
          widget.intake.ester,
        );

        final supplyItemDropdownItems = [
          DropdownMenuItem<SupplyItem?>(
            value: null,
            child: Text(localizations.none),
          ),
          ...supplyItemOptions.map(
            (item) => DropdownMenuItem<SupplyItem?>(
              value: item,
              child: Text(item.name),
            ),
          ),
        ];

        return ModelForm(
          title: localizations.editIntake,
          avatar: widget.intake.administrationRoute.icon,
          submitButtonLabel: localizations.save,
          isFormValid: _isFormValid,
          saveChanges: (!isLoading && _isFormValid)
              ? () => _editIntake(medicationIntakeProvider, supplyItemProvider,
                  widget.intake, _selectedSupplyItem)
              : () {},
          onDelete: () async {
            final confirmed = await IntakesPage.confirmDeleteIntake(context);
            if (confirmed == false) return;
            _deleteIntake(
                medicationIntakeProvider, supplyItemProvider, widget.intake);
          },
          fields: [
            FormDateTimeField(
              label: localizations.date,
              datetime: _takenDate,
              onChanged: _onTakenDateChanged,
            ),
            FormSpacer(),
            FormTextField(
              controller: _takenDoseController,
              label: localizations.amount,
              onChanged: _onTakenDoseChanged,
              inputType: TextInputType.number,
              suffixText: widget.intake.molecule.unit,
              errorText: _takenDoseError,
              regexFormatter: r'[0-9.,]',
            ),
            if (_selectedSupplyItem case final supplyItem?)
              FormInfoText(
                infoText: supplyItem.localizedSupplyAmount(
                  localizations,
                  _takenDose,
                  widget.intake.molecule.unit,
                ),
              ),
            FormSpacer(),
            FormDropdownField<SupplyItem?>(
              value: _selectedSupplyItem,
              items: supplyItemDropdownItems,
              onChanged: _onSupplyItemChanged,
              label: localizations.supplyItem,
            ),
            if (_isInjection)
              FormDropdownField<InjectionSide>(
                value: _selectedSide,
                items: injectionSideDropdownMenuItems(localizations),
                onChanged: _onInjectionSideChanged,
                label: localizations.injectionSide,
              ),
          ],
        );
      },
    );
  }
}
