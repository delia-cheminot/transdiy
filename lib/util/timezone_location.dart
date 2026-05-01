import 'package:timezone/timezone.dart' as tz;

/// Resolves [id] with [tz.getLocation], falling back to [Etc/UTC] when the name
/// is missing from the embedded database (or the DB is not initialized).
tz.Location timeZoneLocation(String id) {
  try {
    return tz.getLocation(id);
  } on tz.LocationNotFoundException {
    try {
      return tz.getLocation('Etc/UTC');
    } on tz.LocationNotFoundException {
      return tz.UTC;
    }
  }
}
