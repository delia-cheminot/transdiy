import 'package:flutter/material.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/theme/tonal_spot_theme_generator.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();
    final argb = preferences.customThemeSourceArgb;

    return Scaffold(
      appBar: AppBar(title: const Text('Thème')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Thème personnalisé'),
            value: preferences.customThemeEnabled,
            onChanged: (v) => preferences.setCustomThemeEnabled(v),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilledButton(
              onPressed: () async {
                await preferences.setCustomThemeSourceArgb(
                  TonalSpotThemeGenerator.randomSourceArgb(),
                );
              },
              child: const Text('Générer'),
            ),
          ),
          const SizedBox(height: 16),
          if (argb != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Source ARGB: 0x'
                    '${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  _ThemeShowcaseCard(sourceArgb: argb),
                ],
              ),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Aucune graine — appuie sur Générer.'),
            ),
        ],
      ),
    );
  }
}

/// Faux écran M3 (même [ColorScheme] qu’en app pour cette graine) pour juger
/// [primary] / [secondary] / [tertiary] en vrai sur des composants.
class _ThemeShowcaseCard extends StatelessWidget {
  const _ThemeShowcaseCard({required this.sourceArgb});

  final int sourceArgb;

  @override
  Widget build(BuildContext context) {
    final schemes = TonalSpotThemeGenerator.colorSchemesForSourceArgb(
      sourceArgb,
    );
    final scheme = Theme.of(context).brightness == Brightness.dark
        ? schemes.dark
        : schemes.light;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: ThemeData(colorScheme: scheme, useMaterial3: true),
        child: Builder(
          builder: (context) {
            final c = ColorScheme.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: c.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.palette,
                          size: 18,
                          color: c.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Aperçu thème',
                          style: TextStyle(
                            color: c.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton(
                        onPressed: () {},
                        child: const Text('Action principale'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: c.secondary,
                          foregroundColor: c.onSecondary,
                        ),
                        child: const Text('Action secondaire'),
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: c.tertiary,
                          foregroundColor: c.onTertiary,
                        ),
                        child: const Text('Action tertiaire'),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: c.outlineVariant),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Text(
                    'Lorem dolor sit, pour voir le texte (onSurface) et les '
                    'lignes sur surface.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: c.onSurfaceVariant),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
