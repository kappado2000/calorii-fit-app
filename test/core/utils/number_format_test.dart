import 'package:flutter_test/flutter_test.dart';

import 'package:calorie_app/core/utils/number_format.dart';

void main() {
  group('formatThousands', () {
    test('leaves numbers under 1000 unchanged', () {
      expect(formatThousands(0), '0');
      expect(formatThousands(47), '47');
      expect(formatThousands(999), '999');
    });

    test('groups by 3 digits with a "." separator', () {
      expect(formatThousands(1000), '1.000');
      expect(formatThousands(2047), '2.047');
      expect(formatThousands(123456), '123.456');
    });

    test('preserves a leading "-" for negative values', () {
      expect(formatThousands(-500), '-500');
      expect(formatThousands(-1234), '-1.234');
    });
  });

  group('formatSignedThousands', () {
    test('prefixes a "+" for positive values', () {
      expect(formatSignedThousands(312), '+312');
      expect(formatSignedThousands(1234), '+1.234');
    });

    test('does not double up the "-" sign for negative values', () {
      expect(formatSignedThousands(-180), '-180');
      expect(formatSignedThousands(-1500), '-1.500');
    });

    test('does not prefix "+" for zero', () {
      expect(formatSignedThousands(0), '0');
    });
  });
}
