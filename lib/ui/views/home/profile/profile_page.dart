import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mona/data/providers/medication_schedule_provider.dart';
import 'package:mona/services/preferences_service.dart';
import 'package:mona/ui/views/home/profile/notifications_page.dart';
import 'package:mona/ui/views/home/profile/schedules_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _checkForUpdates(BuildContext context) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse(
            'https://api.github.com/repos/melinokey/mona-hrt/releases/latest'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');
        final assets = data['assets'] as List;

        if (!context.mounted) return;

        if (currentVersion != latestVersion) {
          _showUpdateDialog(context, currentVersion, latestVersion, assets);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your app is up to date!')),
          );
        }
      } else {
        throw Exception('Failed to fetch latest release');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not check for updates right now.')),
        );
      }
    }
  }

  void _showUpdateDialog(BuildContext context, String current, String latest, List assets) {
    final apkAssets = assets.where((a) => a['name'].toString().endsWith('.apk')).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version $latest is available! (Current: $current)\n\nSelect your architecture to download:'),
            const SizedBox(height: 12),
            ...apkAssets.map((asset) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(asset['name'].toString(), style: const TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.download),
              onTap: () {
                Navigator.pop(context);
                _downloadAndInstall(context, asset['browser_download_url'], asset['name']);
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstall(BuildContext context, String url, String fileName) async {

    if (!await Permission.requestInstallPackages.request().isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission is required to install updates.')),
        );
      }
      return;
    }

    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Downloading...'),
          content: ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (context, progress, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 16),
                  Text('${(progress * 100).toStringAsFixed(1)}%'),
                ],
              );
            },
          ),
        ),
      );
    }

    try {
      final dir = await getTemporaryDirectory();
      final savePath = '${dir.path}/$fileName';

      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      final contentLength = response.contentLength ?? 1;
      int downloadedLength = 0;

      final file = File(savePath);
      final sink = file.openWrite();

      await response.stream.forEach((chunk) {
        sink.add(chunk);
        downloadedLength += chunk.length;
        progressNotifier.value = downloadedLength / contentLength;
      });

      await sink.close();
      client.close();

      if (context.mounted) {
        Navigator.pop(context);
      }

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open installer: ${result.message}')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download failed. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicationScheduleProvider =
        context.watch<MedicationScheduleProvider>();
    final preferencesService = context.watch<PreferencesService>();

    if (medicationScheduleProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Schedules'),
            subtitle: Text(medicationScheduleProvider.schedules.isEmpty
                ? 'No schedules'
                : '${medicationScheduleProvider.schedules.length} created'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => SchedulesPage(),
              ));
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            subtitle: Text(preferencesService.notificationsEnabled
                ? 'Enabled at ${preferencesService.notificationTime.format(context)}'
                : 'Disabled'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (context) => const NotificationsPage(),
              ));
            },
          ),
          if (Platform.isAndroid) ...[
            const Divider(),
            ListTile(
              title: const Text('Check for Updates'),
              subtitle: const Text('Download the latest version from GitHub'),
              trailing: const Icon(Icons.system_update),
              onTap: () => _checkForUpdates(context),
            ),
          ],
        ],
      ),
    );
  }
}
