import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import '../utils/auth_exception.dart';

class SessioniService {
  final String token;
  final String _baseUrl;

  SessioniService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  Future<void> sincronizzaSessione({
    int? schedaId,
    required DateTime inizio,
    required DateTime fine,
    String? note,
    required List<Map<String, dynamic>> serie,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/workouts/sync');
    final body = <String, dynamic>{
      if (schedaId != null) 'schedaId': schedaId,
      'startTime': inizio.toIso8601String(),
      'endTime': fine.toIso8601String(),
      if (note != null && note.isNotEmpty) 'note': note,
      'sets': serie,
    };

    final response = await http
        .post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 401) throw const UnauthorizedException();
    if (response.statusCode != 200) {
      throw Exception('Sync sessione fallita: ${response.statusCode}');
    }
  }
}
