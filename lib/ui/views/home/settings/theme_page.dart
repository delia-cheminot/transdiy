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
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Thème personnalisé'),
            value: preferences.customThemeEnabled,
            onChanged: (v) => preferences.setCustomThemeEnabled(v),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () async {
              final result = TonalSpotThemeGenerator.generateWithRandomBase();
              await preferences.setCustomThemeSourceArgb(result.sourceArgb);
            },
            child: const Text('Générer'),
          ),
          const SizedBox(height: 16),
          if (argb != null) ...[
            Text(
              'Source ARGB: 0x${argb.toRadixString(16).toUpperCase().padLeft(8, '0')}',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color(argb),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Couleur source (après DislikeAnalyzer). Active le switch pour appliquer.',
                  ),
                ),
              ],
            ),
          ] else
            const Text('Aucune graine — appuie sur Générer.'),
        ],
      ),
    );
  }
}
