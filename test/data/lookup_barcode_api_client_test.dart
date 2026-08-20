import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:calorie_app/data/datasources/remote/cloud_functions/lookup_barcode_api_client.dart';

void main() {
  test('lookup returns a FoodProduct when the barcode is recognized', () async {
    final client = LookupBarcodeApiClient(
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'result': {
              'product': {'name': 'Iaurt grecesc', 'brand': 'Test Brand', 'kcalPer100g': 97},
            },
          }),
          200,
        );
      }),
    );

    final product = await client.lookup('5901234123457');

    expect(product, isNotNull);
    expect(product!.name, 'Iaurt grecesc');
    expect(product.kcalPer100g, 97);
  });

  test('lookup returns null when the product is not found (not an error)', () async {
    final client = LookupBarcodeApiClient(
      httpClient: MockClient((request) async {
        return http.Response(jsonEncode({'result': {'product': null}}), 200);
      }),
    );

    final product = await client.lookup('0000000000000');

    expect(product, isNull);
  });

  test('lookup throws LookupBarcodeException on a server error', () async {
    final client = LookupBarcodeApiClient(
      httpClient: MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': {'message': 'Internal error'},
          }),
          500,
        );
      }),
    );

    expect(client.lookup('5901234123457'), throwsA(isA<LookupBarcodeException>()));
  });
}
