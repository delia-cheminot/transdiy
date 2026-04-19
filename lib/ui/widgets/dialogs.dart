import 'package:flutter/material.dart';
import 'package:mona/l10n/build_context_extensions.dart';

class Dialogs {
  static Future<bool?> confirmDeleteDialog({
    required BuildContext context,
    String? title,
    String? content,
    String? cancel,
    String? confirm,
  }) {
    final l10n = context.l10n;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? l10n.deleteElement),
          content: Text(content ?? l10n.irreversibleAction),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancel ?? l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirm ?? l10n.delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        );
      },
    );
  }
}
