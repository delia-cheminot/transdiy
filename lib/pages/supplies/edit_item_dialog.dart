import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transdiy/data/supply_item_model.dart';
import 'package:transdiy/providers/supplies_state.dart';

class EditItemDialog extends StatefulWidget {
  final SupplyItem item;

  EditItemDialog({required this.item});

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _volumeController;
  late TextEditingController _usedVolumeController;
  String? _usedVolumeError;

  @override
  void initState() {
    super.initState();
    _volumeController =
        TextEditingController(text: widget.item.volume.toString());
    _usedVolumeController =
        TextEditingController(text: widget.item.usedVolume.toString());
  }

  @override
  void dispose() {
    _volumeController.dispose();
    _usedVolumeController.dispose();
    super.dispose();
  }

  double? _parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }

  void _setError(String? error) {
    setState(() {
      _usedVolumeError = error;
    });
  }

  bool _validateInputs() {
    final volume = _parseDouble(_volumeController.text);
    final usedVolume = _parseDouble(_usedVolumeController.text);

    if (volume == null || usedVolume == null) {
      _setError(null);
      return false;
    }

    if (usedVolume > volume) {
      _setError('Volume utilisé ne peut pas dépasser le volume total');
      return false;
    }

    _setError(null);
    return true;
  }

  void _saveChanges() {
    if (!_validateInputs()) return;

    widget.item.setFields(
      newVolume: _parseDouble(_volumeController.text)!,
      newUsedVolume: _parseDouble(_usedVolumeController.text)!,
    );
    final suppliesState = Provider.of<SuppliesState>(context, listen: false);
    suppliesState.updateItem(widget.item);
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer ?'),
          content: Text(
              'Voulez-vous vraiment supprimer cet élément ? Cette action est irréversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      final suppliesState = Provider.of<SuppliesState>(context, listen: false);
      // We edit the item in the database, so it must have an ID already.
      suppliesState.deleteItem(widget.item.id!);
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
              onPressed: _validateInputs() ? _saveChanges : null,
              child: Text('Sauvegarder'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
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
                  errorText: _usedVolumeError,
                  suffixIcon:
                      _usedVolumeError != null ? Icon(Icons.error) : null,
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
    );
  }
}
