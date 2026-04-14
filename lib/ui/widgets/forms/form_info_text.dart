import 'package:flutter/material.dart';

class FormInfoText extends StatelessWidget {
  final String infoText;

  const FormInfoText({required this.infoText, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
              text: infoText,
            ),
          ],
        ),
      ),
    );
  }
}
