import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/services/dialog_service.dart';
import 'package:transdiy/supply_item/supplies_state.dart';
import 'package:transdiy/supply_item/supply_item.dart';
import 'package:transdiy/supply_item/supply_item_manager.dart';

class EditItemDialog extends StatefulWidget {
  final SupplyItem item;

  EditItemDialog({required this.item});

  @override
  State<EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _volumeController;
  late TextEditingController _usedVolumeController;
  late TextEditingController _concentrationController;
  late TextEditingController _nameController;

  bool _isFormValid = false;

  Map<String, String?> _fieldErrors = {
    'name': null,
    'volume': null,
    'usedVolume': null,
    'concentration': null,
  };

  @override
  void initState() {
    super.initState();
    _volumeController =
        TextEditingController(text: widget.item.volume.toString());
    _usedVolumeController =
        TextEditingController(text: widget.item.usedVolume.toString());
    _concentrationController =
        TextEditingController(text: widget.item.concentration.toString());
    _nameController = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _usedVolumeController.dispose();
    _concentrationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _fieldErrors['name'] = SupplyItem.validateName(_nameController.text);
      _fieldErrors['volume'] =
          SupplyItem.validateVolume(_volumeController.text);
      _fieldErrors['usedVolume'] = SupplyItem.validateUsedVolume(
        _usedVolumeController.text,
        _volumeController.text,
      );
      _fieldErrors['concentration'] =
          SupplyItem.validateConcentration(_concentrationController.text);

      _isFormValid = _fieldErrors.values.every((error) => error == null);
    });
  }

  void _saveChanges() {
    double? parseDouble(String text) {
      final sanitizedText = text.replaceAll(',', '.');
      return double.tryParse(sanitizedText);
    }

    if (!_isFormValid) return;
    final suppliesState = Provider.of<SuppliesState>(context, listen: false);
    SupplyItemManager(suppliesState).setFields(
      widget.item,
      newName: _nameController.text,
      newVolume: parseDouble(_volumeController.text)!,
      newUsedVolume: parseDouble(_usedVolumeController.text)!,
      newConcentration: parseDouble(_concentrationController.text)!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await DialogService.confirmDelete(context);

    if (confirmed == true) {
      if (!mounted) return;
      final suppliesState = Provider.of<SuppliesState>(context, listen: false);
      suppliesState.deleteItem(widget.item);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _isFormValid ? _saveChanges : null,
              child: Text('Sauvegarder'),
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
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom',
                    errorText: _fieldErrors['name'],
                    suffixIcon:
                        _fieldErrors['name'] != null ? Icon(Icons.error) : null,
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: _volumeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Volume',
                    suffixText: 'ml',
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: _usedVolumeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Volume utilisé',
                    suffixText: 'ml',
                    errorText: _fieldErrors['usedVolume'],
                    suffixIcon: _fieldErrors['usedVolume'] != null
                        ? Icon(Icons.error)
                        : null,
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: TextField(
                  controller: _concentrationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Concentration',
                    suffixText: 'mg/ml',
                    errorText: _fieldErrors['concentration'],
                    suffixIcon: _fieldErrors['concentration'] != null
                        ? Icon(Icons.error)
                        : null,
                  ),
                  onChanged: (value) => _validateInputs(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Divider(),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _confirmDelete,
                  child: Text('Supprimer'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
