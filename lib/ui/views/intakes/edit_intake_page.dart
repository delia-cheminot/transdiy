import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:mona/controllers/supply_item_manager.dart';
import 'package:mona/data/model/administration_route.dart';
import 'package:mona/data/model/medication_intake.dart';
import 'package:mona/data/model/supply_item.dart';
import 'package:mona/data/providers/medication_intake_provider.dart';
import 'package:mona/data/providers/supply_item_provider.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/dialogs.dart';
import 'package:mona/ui/widgets/forms/form_date_field.dart';
import 'package:mona/ui/widgets/forms/form_dropdown_field.dart';
import 'package:mona/ui/widgets/forms/form_text_field.dart';
import 'package:provider/provider.dart';

class EditIntakePage extends StatefulWidget {
  final MedicationIntake intake;

  EditIntakePage(this.intake);

  @override
  State<EditIntakePage> createState() => _EditIntakePageState();
}

class _EditIntakePageState extends State<EditIntakePage> {
  late DateTime _takenDate;
  late TextEditingController _takenDoseController;
  late Decimal _takenDose;
  InjectionSide? _selectedSide;
  bool _hasInitializedSide = false;
  SupplyItem? _selectedSupplyItem;
  bool _hasInitializedSupplyItem = false;

  String? get _takenDoseError =>
      MedicationIntake.validateDose(_takenDoseController.text);

  bool get _isFormValid => _takenDoseError == null;

  bool get _isInjection =>
      widget.intake.administrationRoute == AdministrationRoute.injection;

  void _editIntake(MedicationIntakeProvider medicationIntakeProvider,
      SupplyItemProvider supplyItemProvider,
      MedicationIntake intake, SupplyItem? supplyItem) async {
    if (!_isFormValid) return;
    if (!mounted) return;

    if (supplyItem != null) {
      Decimal doseDifference = intake.dose - _takenDose;
      SupplyItemManager(supplyItemProvider).useDose(supplyItem, -doseDifference); // Invert the difference
    }

    MedicationIntake updatedIntake = intake.copyWith(
        takenDateTime: _takenDate,
        dose: _takenDose,
        side: _selectedSide
    );

    medicationIntakeProvider.updateIntake(updatedIntake);
    Navigator.of(context).pop();
  }

  void _deleteIntake(MedicationIntakeProvider medicationIntakeProvider,
      MedicationIntake intake) {
    if (!mounted) return;

    medicationIntakeProvider.deleteIntake(intake);
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
    });
  }

  void _onTakenDoseChanged() {
    final dose = Decimal.tryParse(
      _takenDoseController.text.replaceAll(',', '.'),
    );
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
    _takenDate = widget.intake.takenDateTime ?? DateTime.now();
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
    return Consumer2<MedicationIntakeProvider, SupplyItemProvider>(
      builder: (context, medicationIntakeProvider, supplyItemProvider, child) {

        final bool isLoading =
            medicationIntakeProvider.isLoading || supplyItemProvider.isLoading;

        if (!isLoading && !_hasInitializedSide && _isInjection) {
          _selectedSide = widget.intake.side;
          _hasInitializedSide = true;
        }

        if (!isLoading && !_hasInitializedSupplyItem) {
          _selectedSupplyItem = supplyItemProvider.getMostUsedItemForMedication(
            widget.intake.molecule,
            widget.intake.administrationRoute,
            widget.intake.ester,
          );
          _hasInitializedSupplyItem = true;
        }

        final supplyItemOptions = supplyItemProvider.getItemsForMedication(
          widget.intake.molecule,
          widget.intake.administrationRoute,
          widget.intake.ester,
        );

        final supplyItemDropdownItems = [
          const DropdownMenuItem<SupplyItem?>(
            value: null,
            child: Text('None'),
          ),
          ...supplyItemOptions.map(
                (item) => DropdownMenuItem<SupplyItem?>(
              value: item,
              child: Text(item.name),
            ),
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit intake'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormDateField(
                      date: _takenDate,
                      label: 'Date',
                      onChanged: _onTakenDateChanged,
                    ),
                    FormTextField(
                      controller: _takenDoseController,
                      label: 'Amount',
                      onChanged: _onTakenDoseChanged,
                      inputType: TextInputType.number,
                      suffixText: widget.intake.molecule.unit,
                      errorText: _takenDoseError,
                      regexFormatter: r'[0-9.,]',
                    ),
                    if (_selectedSupplyItem != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.info_outline,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text:
                                ' $_takenDose ${widget.intake.molecule.unit} = ${_selectedSupplyItem!.getAmount(_takenDose)} ${_selectedSupplyItem!.administrationRoute.unit}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    FormDropdownField<SupplyItem?>(
                      value: _selectedSupplyItem,
                      items: supplyItemDropdownItems,
                      onChanged: _onSupplyItemChanged,
                      label: 'Supply item',
                    ),
                    if (_isInjection)
                      FormDropdownField<InjectionSide>(
                        value: _selectedSide,
                        items: InjectionSideDropdown.menuItems,
                        onChanged: _onInjectionSideChanged,
                        label: 'Injection side',
                      ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: (!isLoading && _isFormValid)
                              ? () => _editIntake(
                              medicationIntakeProvider, supplyItemProvider, widget.intake, _selectedSupplyItem)
                              : null, // null = bouton grisé
                          child: const Text('Edit intake'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () async {
                            final confirmed = await Dialogs.confirmDeleteIntake(context);
                            if (confirmed == true) {
                              _deleteIntake(medicationIntakeProvider, widget.intake);
                            }
                          },
                          child: const Text('Delete intake'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
