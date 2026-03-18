import 'package:flutter/material.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/widgets/forms/dismiss_keyboard_single_child_scroll_view.dart';

class ModelForm extends StatelessWidget {
  final String title;
  final IconData? avatar;
  final List<Widget> fields;
  final VoidCallback? onDelete;
  final bool isFormValid;
  final VoidCallback saveChanges;
  final String submitButtonLabel;

  const ModelForm({
    required this.title,
    this.avatar,
    required this.fields,
    this.onDelete,
    required this.isFormValid,
    required this.saveChanges,
    required this.submitButtonLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: DismissKeyboardSingleChildScrollView(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (avatar != null) ...[
                const SizedBox(height: 32),
                Center(
                  child: CircleAvatar(
                    radius: 64,
                    child: Icon(avatar, size: 64),
                  ),
                ),
                const SizedBox(height: 32),
              ],
              ...fields,
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: borderPadding,
            left: borderPadding,
            right: borderPadding,
            bottom: borderPadding + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Row(
            children: [
              if (onDelete != null) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                    ),
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                  ),
                ),
              ],
              const SizedBox(width: borderPadding),
              Expanded(
                child: FilledButton.icon(
                  onPressed: isFormValid ? saveChanges : null,
                  icon: onDelete != null ? const Icon(Icons.save) : null,
                  label: Text(submitButtonLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
