import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';
import '../../../models/food_product.dart';

final aiFoodLookupApiClientProvider = Provider<AiFoodLookupApiClient>((ref) => AiFoodLookupApiClient());

class AiFoodLookupException implements Exception {
  AiFoodLookupException(this.message, {this.status});
  final String message;

  /// The callable-function wire protocol's error status (e.g.
  /// `RESOURCE_EXHAUSTED`, `UNAUTHENTICATED`) — mirrors AnalyzePhotoException.
  final String? status;

  bool get isQuotaExceeded => status == 'RESOURCE_EXHAUSTED';
  bool get isUnauthenticated => status == 'UNAUTHENTICATED';

  @override
  String toString() => 'AiFoodLookupException: $message';
}

/// Talks to the `aiFoodLookup` Cloud Function — a fallback offered only
/// when the regular product search (curated table + Open Food Facts) finds
/// nothing for a manually-typed name, asking Claude to identify the food
/// and estimate its average nutrition per 100g. Returns null when Claude
/// itself wasn't confident enough to offer anything, never a low-quality
/// guess presented as a real match.
class AiFoodLookupApiClient {
  AiFoodLookupApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<FoodProduct?> lookup(String query, {required String idToken}) async {
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'};
    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      if (appCheckToken != null) headers['X-Firebase-AppCheck'] = appCheckToken;
    } catch (_) {
      // Ignored — the lookup proceeds without the header.
    }

    final response = await _httpClient.post(
      Uri.parse(AppConfig.aiFoodLookupUrl),
      headers: headers,
      body: jsonEncode({
        'data': {'query': query},
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      final error = decoded['error'] as Map<String, dynamic>?;
      throw AiFoodLookupException(
        error?['message'] as String? ?? 'HTTP ${response.statusCode}',
        status: error?['status'] as String?,
      );
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw AiFoodLookupException('Missing result in response.');
    }
    final productJson = result['product'] as Map<String, dynamic>?;
    if (productJson == null) return null;

    final matched = FoodProduct.fromJson(productJson);
    return FoodProduct(
      name: matched.name,
      kcalPer100g: matched.kcalPer100g,
      proteinPer100g: matched.proteinPer100g,
      carbsPer100g: matched.carbsPer100g,
      fatPer100g: matched.fatPer100g,
      micronutrients: matched.micronutrients,
      isAiEstimate: true,
    );
  }

  void dispose() => _httpClient.close();
}
