import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/domain/usecases/weight_scale_ble_parser.dart';

void main() {
  test('parses an SI (kg) measurement using 5g resolution', () {
    // 70.5 kg / 0.005 = 14100 = 0x3714 -> low=0x14 (20), high=0x37 (55)
    final bytes = [0x00, 20, 55];
    expect(parseWeightScaleMeasurementKg(bytes), closeTo(70.5, 0.001));
  });

  test('parses an Imperial (lb) measurement and converts to kg', () {
    // 154.5 lb / 0.01 = 15450 = 0x3C5A -> low=0x5A (90), high=0x3C (60)
    final bytes = [0x01, 90, 60];
    final expectedKg = 154.5 * 0.45359237;
    expect(parseWeightScaleMeasurementKg(bytes), closeTo(expectedKg, 0.001));
  });

  test('returns null for too-short input', () {
    expect(parseWeightScaleMeasurementKg([0x00, 20]), isNull);
    expect(parseWeightScaleMeasurementKg([]), isNull);
  });

  test('ignores extra optional fields (timestamp/user-id) beyond the weight bytes', () {
    final bytes = [0x00, 20, 55, 7, 233, 8, 15, 10, 30, 0, 42];
    expect(parseWeightScaleMeasurementKg(bytes), closeTo(70.5, 0.001));
  });
}
