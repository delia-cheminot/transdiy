/// Android `--flavor` is forwarded as a compile-time define by the Flutter tool.
/// See `android/app/build.gradle` (`play`, `standalone`, `legacy`).
const String _flutterAppFlavor = String.fromEnvironment(
  'FLUTTER_APP_FLAVOR',
  defaultValue: '',
);

/// Play Store build: no sideload/APK update UI and no [REQUEST_INSTALL_PACKAGES].
bool get isPlayStoreDistribution => _flutterAppFlavor == 'play';

/// Signed sideload build distributed as a single GitHub APK named `mona-*.apk`.
bool get isStandaloneDistribution => _flutterAppFlavor == 'standalone';

/// Unsigned (debug-signed) sideload build distributed as per-ABI / universal
/// APKs (`app-<abi>-release.apk`, `app-universal-release.apk`).
bool get isLegacyDistribution => _flutterAppFlavor == 'legacy';
