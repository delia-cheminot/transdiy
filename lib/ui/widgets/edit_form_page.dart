import 'package:flutter/material.dart';
import 'package:mona/ui/constants/dimensions.dart';

class EditFormPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onDelete;
  final bool isFormValid;
  final VoidCallback saveChanges;

  const EditFormPage({
    required this.title,
    required this.child,
    required this.onDelete,
    required this.isFormValid,
    required this.saveChanges,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: isFormValid ? saveChanges : null,
              child: Text('Sauvegarder'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              const SizedBox(height: 8),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Divider(),
                  ),
                  Container(
                    padding: pagePadding,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onDelete,
                      child: Text('Supprimer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
