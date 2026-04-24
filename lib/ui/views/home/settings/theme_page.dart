import 'package:flutter/material.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/theme/custom_theme_schemes.dart';
import 'package:mona/theme/custom_theme_settings.dart';
import 'package:mona/theme/tonal_spot_theme_generator.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();
    final customTheme = preferences.customTheme;

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
                await preferences.setCustomTheme(
                  customTheme.copyWith(
                      seedArgb: TonalSpotThemeGenerator.randomSourceArgb()),
                );
              },
              child: const Text('Générer'),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Variante M3',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 4),
                InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DynamicSchemeVariant>(
                      isExpanded: true,
                      value: customTheme.variant,
                      items: [
                        for (final v in DynamicSchemeVariant.values)
                          DropdownMenuItem(
                            value: v,
                            child: Text(
                              _variantLabelFr(v),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        preferences
                            .setCustomTheme(customTheme.copyWith(variant: v));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Contraste',
                    style: Theme.of(context).textTheme.titleSmall),
                Text(
                  _contrastLabel(customTheme.contrastLevel),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Slider(
                  value: customTheme.contrastLevel.clamp(
                    CustomThemeSettings.contrastMin,
                    CustomThemeSettings.contrastMax,
                  ),
                  min: CustomThemeSettings.contrastMin,
                  max: CustomThemeSettings.contrastMax,
                  divisions: 2,
                  label: _contrastLabel(customTheme.contrastLevel),
                  onChanged: (v) {
                    preferences.setCustomTheme(
                      customTheme.copyWith(
                          contrastLevel: _snapContrastToStop(v)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Source ARGB: 0x'
                  '${customTheme.seedArgb.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                _ThemeShowcaseCard(settings: customTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Slider à 3 crans pour M3 : -1, 0, 1.
double _snapContrastToStop(double value) {
  if (value <= -0.5) return -1.0;
  if (value >= 0.5) return 1.0;
  return 0.0;
}

String _contrastLabel(double level) {
  if (level <= -0.5) return 'Faible (accessibilité minimale)';
  if (level >= 0.5) return 'Élevé (accessibilité max.)';
  return 'Standard (spec M3)';
}

String _variantLabelFr(DynamicSchemeVariant v) {
  return switch (v) {
    DynamicSchemeVariant.tonalSpot => 'Tonal spot (défaut M3)',
    DynamicSchemeVariant.fidelity => 'Fidélité à la graine',
    DynamicSchemeVariant.monochrome => 'Monochrome',
    DynamicSchemeVariant.neutral => 'Neutre (peu de chroma)',
    DynamicSchemeVariant.vibrant => 'Vibrant',
    DynamicSchemeVariant.expressive => 'Expressif',
    DynamicSchemeVariant.content => 'Contenu (proche fidélité)',
    DynamicSchemeVariant.rainbow => 'Arc-en-ciel (ludique)',
    DynamicSchemeVariant.fruitSalad => 'Fruit salad (ludique)',
  };
}

class _ThemeShowcaseCard extends StatelessWidget {
  const _ThemeShowcaseCard({required this.settings});

  final CustomThemeSettings settings;

  @override
  Widget build(BuildContext context) {
    final schemes = CustomThemeSchemes.fromSettings(settings);
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
