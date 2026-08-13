/// Parses the Bluetooth SIG "Weight Measurement" characteristic
/// (0x2A9D, part of the standard Weight Scale Service 0x181D) — the
/// generic profile most consumer smart scales implement, which is why
/// this app can connect to them directly over BLE rather than needing a
/// per-vendor SDK (see project plan).
///
/// Layout: byte 0 = flags; bytes 1-2 = weight (uint16 LE); flag bit 0
/// selects the unit/resolution (0 = SI, 5g steps; 1 = Imperial, 0.01lb
/// steps). Optional timestamp/user-id/BMI+height fields may follow but
/// aren't needed here.
double? parseWeightScaleMeasurementKg(List<int> bytes) {
  if (bytes.length < 3) return null;

  final flags = bytes[0];
  final isImperial = (flags & 0x01) != 0;
  final raw = bytes[1] | (bytes[2] << 8);

  if (isImperial) {
    final pounds = raw * 0.01;
    return pounds * 0.45359237;
  }
  return raw * 0.005;
}
