/// Formats an integer with a "." thousands separator (Romanian convention,
/// e.g. 1234 -> "1.234"), preserving a leading "-" if present.
String formatThousands(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return negative ? '-$buffer' : buffer.toString();
}

/// Same as [formatThousands] but prefixes a "+" for positive values —
/// used for deltas like a calorie deficit/surplus where the sign carries
/// meaning (e.g. "+312" vs "-180").
String formatSignedThousands(int value) {
  final formatted = formatThousands(value);
  return value > 0 ? '+$formatted' : formatted;
}
