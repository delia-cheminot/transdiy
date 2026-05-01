import 'package:flutter/material.dart';
import 'package:mona/l10n/build_context_extensions.dart';

class LegacyDeprecationPage extends StatelessWidget {
  const LegacyDeprecationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.deprecated)),
      body: const SizedBox.shrink(),
    );
  }
}
