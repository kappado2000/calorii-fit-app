import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/core/version/semantic_version.dart';

void main() {
  group('SemanticVersion.tryParse', () {
    test('parses a full major.minor.patch string', () {
      final v = SemanticVersion.tryParse('1.2.3')!;
      expect(v.major, 1);
      expect(v.minor, 2);
      expect(v.patch, 3);
    });

    test('defaults missing components to 0', () {
      expect(SemanticVersion.tryParse('2')!.toString(), '2.0.0');
      expect(SemanticVersion.tryParse('2.5')!.toString(), '2.5.0');
    });

    test('returns null for malformed input instead of throwing', () {
      expect(SemanticVersion.tryParse('abc'), isNull);
      expect(SemanticVersion.tryParse('1.2.3.4'), isNull);
      expect(SemanticVersion.tryParse(''), isNull);
    });
  });

  group('SemanticVersion comparison', () {
    test('compares by major, then minor, then patch', () {
      expect(SemanticVersion.tryParse('1.0.0')! < SemanticVersion.tryParse('2.0.0')!, isTrue);
      expect(SemanticVersion.tryParse('1.1.0')! < SemanticVersion.tryParse('1.2.0')!, isTrue);
      expect(SemanticVersion.tryParse('1.1.1')! < SemanticVersion.tryParse('1.1.2')!, isTrue);
      expect(SemanticVersion.tryParse('1.1.0')! >= SemanticVersion.tryParse('1.1.0')!, isTrue);
    });

    test('a higher patch does not outrank a higher minor', () {
      expect(SemanticVersion.tryParse('1.1.9')! < SemanticVersion.tryParse('1.2.0')!, isTrue);
    });
  });
}
