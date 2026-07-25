import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/scheda_remota.dart';
import '../utils/api_config.dart';
import '../utils/auth_exception.dart';

class SchedeService {
  SchedeService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final String token;
  final String _baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<List<SchedaRemota>> getSchede() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/schede'), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => SchedaRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore schede (${response.statusCode})');
  }

  Future<List<EsercizioInSchedaRemota>> getEserciziScheda(int schedaId) async {
    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/scheda-esercizi/$schedaId'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => EsercizioInSchedaRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore esercizi (${response.statusCode})');
  }

  Future<List<SchedaRemota>> getModelliSchede() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/schede/modelli'), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => SchedaRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore modelli (${response.statusCode})');
  }

  String risolviUrlImmagine(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http')) return url;
    return '$_baseUrl/$url';
  }
}
