class MathHelper {
  /// Parses a string to a double, replacing commas with dots.
  static double? parseDouble(String text) {
    final sanitizedText = text.replaceAll(',', '.');
    return double.tryParse(sanitizedText);
  }

  /// Rounds a double to a given number of decimal places.
  static double roundDouble(double value, int places) {
    return double.parse(value.toStringAsFixed(places));
  }
}