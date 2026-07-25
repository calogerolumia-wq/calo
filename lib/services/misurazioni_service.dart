import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/misurazione_remota.dart';
import '../utils/api_config.dart';
import '../utils/auth_exception.dart';

class MisurazioniService {
  MisurazioniService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final String token;
  final String _baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<List<MisurazioneRemota>> getMisurazioni(int utenteId) async {
    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/utenti/$utenteId/misurazioni'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => MisurazioneRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore misurazioni: ${response.statusCode}');
  }

  Future<MisurazioneRemota> creaMisurazione(
      int utenteId, MisurazioneRemota misura) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/utenti/$utenteId/misurazioni'),
          headers: _headers,
          body: jsonEncode(misura.toJson()),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      return MisurazioneRemota.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore creazione misurazione: ${response.statusCode}');
  }

  Future<void> eliminaMisurazione(int utenteId, int id) async {
    final response = await http
        .delete(
          Uri.parse('$_baseUrl/api/utenti/$utenteId/misurazioni/$id'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 204) return;
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore eliminazione misurazione: ${response.statusCode}');
  }
}
