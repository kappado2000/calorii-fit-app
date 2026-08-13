import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';
import '../../../models/food_product.dart';

class SearchFoodsException implements Exception {
  SearchFoodsException(this.message);
  final String message;

  @override
  String toString() => 'SearchFoodsException: $message';
}

/// Talks to the `searchFoods` Cloud Function using the plain HTTPS
/// callable-function wire protocol — see functions/src/searchFoods.ts.
class SearchFoodsApiClient {
  SearchFoodsApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<List<FoodProduct>> search(String query) async {
    final response = await _httpClient.post(
      Uri.parse(AppConfig.searchFoodsUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'data': {'query': query},
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final errorMessage = (decoded['error'] as Map<String, dynamic>?)?['message'] as String?;
      throw SearchFoodsException(errorMessage ?? 'HTTP ${response.statusCode}');
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw SearchFoodsException('Missing result in response.');
    }
    final products = result['products'] as List<dynamic>? ?? const [];
    return products.map((p) => FoodProduct.fromJson(p as Map<String, dynamic>)).toList(growable: false);
  }

  void dispose() => _httpClient.close();
}
