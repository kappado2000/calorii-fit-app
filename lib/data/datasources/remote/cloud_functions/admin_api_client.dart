import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';

final adminApiClientProvider = Provider<AdminApiClient>((ref) => AdminApiClient());

class AdminApiException implements Exception {
  AdminApiException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Talks to activateAdmin/generatePremiumCode/redeemPremiumCode — grouped
/// in one client since all three share the exact same small
/// {"data": ...} in / {"result": ...} or {"error": ...} out shape and the
/// same admin/premium-access concern.
class AdminApiClient {
  AdminApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<void> activateAdmin({required String password, required String idToken}) async {
    await _call(AppConfig.activateAdminUrl, {'password': password}, idToken: idToken);
  }

  /// Returns the generated code.
  Future<String> generatePremiumCode({
    required String targetEmail,
    required int durationDays,
    required String idToken,
  }) async {
    final result = await _call(
      AppConfig.generatePremiumCodeUrl,
      {'targetEmail': targetEmail, 'durationDays': durationDays},
      idToken: idToken,
    );
    return result['code'] as String;
  }

  /// Returns the ISO date the account is now premium until.
  Future<String> redeemPremiumCode({required String code, required String idToken}) async {
    final result = await _call(AppConfig.redeemPremiumCodeUrl, {'code': code}, idToken: idToken);
    return result['premiumUntil'] as String;
  }

  Future<Map<String, dynamic>> _call(String url, Map<String, dynamic> data, {required String idToken}) async {
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $idToken'};
    try {
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      if (appCheckToken != null) headers['X-Firebase-AppCheck'] = appCheckToken;
    } catch (_) {
      // Ignored — the call proceeds without the header.
    }

    final response = await _httpClient.post(Uri.parse(url), headers: headers, body: jsonEncode({'data': data}));
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final error = decoded['error'] as Map<String, dynamic>?;
      throw AdminApiException(error?['message'] as String? ?? 'HTTP ${response.statusCode}');
    }
    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw AdminApiException('Missing result in response.');
    }
    return result;
  }

  void dispose() => _httpClient.close();
}
