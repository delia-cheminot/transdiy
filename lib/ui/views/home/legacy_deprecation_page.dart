import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:mona/ui/constants/dimensions.dart';
import 'package:mona/ui/views/home/settings/settings_page.dart';
import 'package:url_launcher/url_launcher.dart';

class LegacyDeprecationPage extends StatelessWidget {
  const LegacyDeprecationPage({super.key});

  static final Uri _releasesUri =
      Uri.parse('https://github.com/mona-hrt/mona/releases/latest');
  static final Uri _playStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.deliacheminot.mona',
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.deprecated)),
      body: SingleChildScrollView(
        padding: pagePadding.add(const EdgeInsets.symmetric(vertical: 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.legacyDeprecationIntro,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            _Step(
              number: 1,
              title: l10n.legacyStep1Title,
              description: l10n.legacyStep1Description,
              action: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const SettingsPage(),
                    ),
                  );
                },
                icon: const Icon(Symbols.settings),
                label: Text(l10n.goToSettings),
              ),
            ),
            _Step(
              number: 2,
              title: l10n.legacyStep2Title,
              description: l10n.legacyStep2Description,
              action: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      launchUrl(_playStoreUri,
                          mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Symbols.shop),
                    label: Text(l10n.openPlayStore),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      launchUrl(_releasesUri,
                          mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Symbols.open_in_new),
                    label: Text(l10n.openLatestRelease),
                  ),
                ],
              ),
            ),
            _Step(
              number: 3,
              title: l10n.legacyStep3Title,
              description: l10n.legacyStep3Description,
            ),
            _Step(
              number: 4,
              title: l10n.legacyStep4Title,
              description: l10n.legacyStep4Description,
            ),
            _Step(
              number: 5,
              title: l10n.legacyStep5Title,
              description: l10n.legacyStep5Description,
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.number,
    required this.title,
    required this.description,
    this.action,
  });

  final int number;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. $title', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description, style: theme.textTheme.bodyMedium),
          if (action != null) ...[
            const SizedBox(height: 8),
            action!,
          ],
        ],
      ),
    );
  }
}
