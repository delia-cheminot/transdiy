/// Android `--flavor` is forwarded as a compile-time define by the Flutter tool.
/// See `android/app/build.gradle` (`play` vs `standalone`).
const String _flutterAppFlavor = String.fromEnvironment(
  'FLUTTER_APP_FLAVOR',
  defaultValue: '',
);

/// Play Store build: no sideload/APK update UI and no [REQUEST_INSTALL_PACKAGES].
bool get isPlayStoreDistribution => _flutterAppFlavor == 'play';
