import 'package:flutter/material.dart';

class Dialogs {
  // TODO refactor this, it's a confirm delete dialog.
  // we should just pass the name of the element or smth
  static Future<bool?> confirmDialog(
      {required BuildContext context,
      String title = "Delete this element?",
      String content = "This action can't be undone.",
      String cancel = "Cancel",
      String confirm = "Delete"}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirm, style: TextStyle(color: Color(0xFFD32F2F))),
            ),
          ],
        );
      },
    );
  }
}
