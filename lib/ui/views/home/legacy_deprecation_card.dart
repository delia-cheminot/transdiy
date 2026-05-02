import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/ui/views/home/legacy_deprecation_page.dart';

class LegacyDeprecationCard extends StatelessWidget {
  const LegacyDeprecationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final foreground = theme.colorScheme.onErrorContainer;

    return Card.filled(
      color: theme.colorScheme.errorContainer,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const LegacyDeprecationPage(),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.error,
            child: Icon(
              Symbols.info,
              color: theme.colorScheme.onError,
            ),
          ),
          title: Text(
            l10n.deprecated,
            style: theme.textTheme.titleMedium?.copyWith(color: foreground),
          ),
          subtitle: Text(
            l10n.legacyVersionMessage,
            style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
          ),
        ),
      ),
    );
  }
}
