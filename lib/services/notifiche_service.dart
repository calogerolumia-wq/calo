import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notifica_remota.dart';
import '../utils/api_config.dart';

class NotificheService {
  NotificheService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final String token;
  final String _baseUrl;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

  Future<List<NotificaRemota>> getMie() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/api/notifiche/mie'), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) => NotificaRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Errore notifiche (${response.statusCode})');
  }
}
