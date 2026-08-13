import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:calorie_app/data/datasources/remote/cloud_functions/search_foods_api_client.dart';

void main() {
  test('parses products from a successful callable-function response', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'result': {
            'products': [
              {
                'barcode': '5900000000000',
                'name': 'Iaurt grecesc',
                'brand': 'Zuzu',
                'kcalPer100g': 97,
                'proteinPer100g': 9,
                'carbsPer100g': 4,
                'fatPer100g': 5,
                'imageUrl': null,
              },
            ],
          },
        }),
        200,
      );
    });

    final client = SearchFoodsApiClient(httpClient: mockClient);
    final products = await client.search('iaurt');

    expect(products, hasLength(1));
    expect(products.first.name, 'Iaurt grecesc');
    expect(products.first.brand, 'Zuzu');
    expect(products.first.kcalPer100g, 97);
    expect(products.first.proteinPer100g, 9);
  });

  test('throws SearchFoodsException with the server message on a non-200 response', () async {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'error': {'message': 'query must be at least 2 characters.'},
        }),
        400,
      );
    });

    final client = SearchFoodsApiClient(httpClient: mockClient);

    expect(() => client.search('a'), throwsA(isA<SearchFoodsException>()));
  });
}
