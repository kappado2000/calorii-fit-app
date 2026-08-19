import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';
import '../../../models/food_product.dart';

class LookupBarcodeException implements Exception {
  LookupBarcodeException(this.message);
  final String message;

  @override
  String toString() => 'LookupBarcodeException: $message';
}

/// Talks to the `lookupBarcode` Cloud Function — see
/// functions/src/lookupBarcode.ts. Returns null when the barcode isn't
/// recognized by Open Food Facts, distinct from a network/server error
/// (which throws), so the scanner screen can offer manual entry only in
/// the "genuinely unknown product" case.
class LookupBarcodeApiClient {
  LookupBarcodeApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<FoodProduct?> lookup(String barcode) async {
    final response = await _httpClient.post(
      Uri.parse(AppConfig.lookupBarcodeUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'data': {'barcode': barcode},
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final errorMessage = (decoded['error'] as Map<String, dynamic>?)?['message'] as String?;
      throw LookupBarcodeException(errorMessage ?? 'HTTP ${response.statusCode}');
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw LookupBarcodeException('Missing result in response.');
    }
    final product = result['product'] as Map<String, dynamic>?;
    return product == null ? null : FoodProduct.fromJson(product);
  }

  void dispose() => _httpClient.close();
}
