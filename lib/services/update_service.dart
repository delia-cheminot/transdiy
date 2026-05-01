import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mona/distribution.dart';
import 'package:mona/l10n/build_context_extensions.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pub_semver/pub_semver.dart';

class UpdateService {
  static const String _releaseUrl =
      'https://api.github.com/repos/delia-cheminot/mona-hrt/releases/latest';

  Future<Map<String, dynamic>?> _fetchLatestRelease() async {
    final response = await http.get(Uri.parse(_releaseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<bool> isUpdateAvailable() async {
    if (isPlayStoreDistribution || !Platform.isAndroid) return false;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final data = await _fetchLatestRelease();

      if (data != null) {
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');

        final current = Version.parse(packageInfo.version);
        final latest = Version.parse(latestVersion);

        return latest > current;
      }
    } catch (e) {
      // Silently fail for background checks
    }
    return false;
  }

  Future<void> checkForUpdates(BuildContext context) async {
    if (isPlayStoreDistribution || !Platform.isAndroid) return;
    final l10n = context.l10n;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final current = Version.parse(currentVersion);

      final data = await _fetchLatestRelease();

      if (data != null) {
        final latestVersion = data['tag_name'].toString().replaceAll('v', '');
        final latest = Version.parse(latestVersion);
        final assets = data['assets'] as List;

        if (!context.mounted) return;

        if (latest > current) {
          final bestAsset = await _getBestAssetForDevice(assets);

          if (!context.mounted) return;

          if (bestAsset != null) {
            _showUpdateDialog(
                context, currentVersion, latestVersion, bestAsset);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.updateNoCompatibleApk)),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.updateAppUpToDate)),
          );
        }
      } else {
        throw Exception('Failed to fetch latest release');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updateCheckNetworkError)),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _getBestAssetForDevice(List assets) async {
    final apkAssets =
        assets.where((a) => a['name'].toString().endsWith('.apk')).toList();
    if (apkAssets.isEmpty) return null;

    if (isStandaloneDistribution) {
      for (var asset in apkAssets) {
        if (asset['name'].toString().toLowerCase().contains('mona-')) {
          return asset;
        }
      }
      return null;
    }

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final supportedAbis = androidInfo.supportedAbis;

    for (String abi in supportedAbis) {
      for (var asset in apkAssets) {
        if (asset['name']
            .toString()
            .toLowerCase()
            .contains(abi.toLowerCase())) {
          return asset;
        }
      }
    }

    final universalAssets = apkAssets
        .where((a) => a['name'].toString().toLowerCase().contains('universal'))
        .toList();

    if (universalAssets.isNotEmpty) return universalAssets.first;

    return apkAssets.first;
  }

  void _showUpdateDialog(BuildContext context, String current, String latest,
      Map<String, dynamic> asset) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.updateDialogTitle),
        content: Text(l10n.updateDialogBody(latest, current)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _downloadAndInstall(
                  context, asset['browser_download_url'], asset['name']);
            },
            child: Text(l10n.updateDownloadAndInstall),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadAndInstall(
      BuildContext context, String url, String fileName) async {
    final l10n = context.l10n;
    if (!await Permission.requestInstallPackages.request().isGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updateInstallPermissionRequired)),
        );
      }
      return;
    }

    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    bool isCancelled = false;
    StreamSubscription? subscription;
    IOSink? sink;
    final client = http.Client();

    final dir = await getTemporaryDirectory();
    final savePath = '${dir.path}/$fileName';
    final file = File(savePath);

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(l10n.updateDownloadingTitle),
            content: ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (ctx, progress, child) {
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
            actions: [
              TextButton(
                onPressed: () async {
                  isCancelled = true;
                  await subscription?.cancel();

                  await sink?.close();
                  if (file.existsSync()) {
                    await file.delete();
                  }

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
                  }
                },
                child: Text(l10n.cancel),
              ),
            ],
          );
        },
      );
    }

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      final contentLength = response.contentLength ?? 1;
      int downloadedLength = 0;

      sink = file.openWrite();

      subscription = response.stream.listen((chunk) {
        if (isCancelled) return;

        sink!.add(chunk);
        downloadedLength += chunk.length;

        double progress = downloadedLength / contentLength;
        progressNotifier.value = progress.clamp(0.0, 1.0);
      });

      await subscription.asFuture();

      if (!isCancelled) {
        await sink.flush();
        await sink.close();

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        final result = await OpenFilex.open(savePath);
        if (result.type != ResultType.done && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(l10n.updateFailedOpenInstaller(result.message))),
          );
        }
      }
    } catch (e) {
      if (!isCancelled && context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.updateDownloadFailed)),
        );
      }
    } finally {
      await sink?.close();
      client.close();
    }
  }
}
