import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/esercizio_remoto.dart';
import '../utils/api_config.dart';
import '../utils/auth_exception.dart';

class EserciziService {
  final String token;
  final String _baseUrl;

  EserciziService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  Future<List<EsercizioRemoto>> getEsercizi() async {
    final uri = Uri.parse('$_baseUrl/api/esercizi');
    final response = await http
        .get(uri, headers: {'Authorization': 'Bearer $token'})
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => EsercizioRemoto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore caricamento esercizi: ${response.statusCode}');
  }
}
