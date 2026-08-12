import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_config.dart';
import '../../../models/analyzed_food_item.dart';

class AnalyzePhotoException implements Exception {
  AnalyzePhotoException(this.message);
  final String message;

  @override
  String toString() => 'AnalyzePhotoException: $message';
}

/// Talks to the `analyzePhoto` Cloud Function using the plain HTTPS
/// callable-function wire protocol ({"data": ...} in, {"result": ...} or
/// {"error": ...} out) — see functions/src/analyzePhoto.ts.
class AnalyzePhotoApiClient {
  AnalyzePhotoApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<AnalyzePhotoResponse> analyze(File photoFile) async {
    final bytes = await photoFile.readAsBytes();
    final mediaType = _mediaTypeForPath(photoFile.path);

    final response = await _httpClient.post(
      Uri.parse(AppConfig.analyzePhotoUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'data': {'imageBase64': base64Encode(bytes), 'mediaType': mediaType},
      }),
    );

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 200) {
      final errorMessage = (decoded['error'] as Map<String, dynamic>?)?['message'] as String?;
      throw AnalyzePhotoException(errorMessage ?? 'HTTP ${response.statusCode}');
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    if (result == null) {
      throw AnalyzePhotoException('Missing result in response.');
    }
    return AnalyzePhotoResponse.fromJson(result);
  }

  String _mediaTypeForPath(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }

  void dispose() => _httpClient.close();
}
