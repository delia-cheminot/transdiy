import 'package:flutter/material.dart';

class Dialogs {

  static const cantBeUndone = Text("This action can't be undone.");
  static const delete = Text("Delete");
  static const cancel = Text("Cancel");

  static Future<bool?> confirmDialog(BuildContext context, Text title, Text content, Text no, Text yes) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: no,
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: yes,
            ),
          ],
        );
      },
    );
  }

  static Future<bool?> confirmDeleteIntake(BuildContext context) {
    return confirmDialog(context,
        const Text("Delete this intake?"),
        cantBeUndone,
        cancel, delete);
  }


  static Future<bool?> confirmDelete(BuildContext context) {
    return confirmDialog(context,
        const Text("Delete this element?"),
        cantBeUndone,
        cancel, delete);
  }
}
