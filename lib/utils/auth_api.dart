import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

class LoginResponse {
  const LoginResponse({
    required this.token,
    required this.id,
    required this.nome,
    required this.cognome,
    required this.email,
    this.username,
    this.mobileAbilitato = true,
    this.featureEsercizi = true,
    this.featureSchede = true,
    this.featureModelliSchede = true,
    this.featureTimer = true,
    this.featureMisurazioni = true,
  });

  final String token;
  final int id;
  final String? nome;
  final String? cognome;
  final String? email;
  final String? username;
  final bool mobileAbilitato;
  final bool featureEsercizi;
  final bool featureSchede;
  final bool featureModelliSchede;
  final bool featureTimer;
  final bool featureMisurazioni;

  String get nomeCompleto {
    final parti = [nome, cognome]
        .where((parte) => parte != null && parte!.trim().isNotEmpty)
        .map((parte) => parte!.trim())
        .toList();
    return parti.isEmpty ? 'Utente' : parti.join(' ');
  }

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String?,
      cognome: json['cognome'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      mobileAbilitato: (json['mobileAbilitato'] as bool?) ?? true,
      featureEsercizi: (json['featureEsercizi'] as bool?) ?? true,
      featureSchede: (json['featureSchede'] as bool?) ?? true,
      featureModelliSchede: (json['featureModelliSchede'] as bool?) ?? true,
      featureTimer: (json['featureTimer'] as bool?) ?? true,
      featureMisurazioni: (json['featureMisurazioni'] as bool?) ?? true,
    );
  }
}

class AuthApi {
  AuthApi({http.Client? client, this.baseUrl = apiBaseUrl})
      : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<LoginResponse> login({
    required String username,
    required String password,
    String? codiceAzienda,
    int? aziendaId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login-mobile');
    final payload = <String, dynamic>{
      'username': username,
      'password': password,
    };

    final codice = codiceAzienda?.trim();
    if (codice != null && codice.isNotEmpty) {
      payload['codiceAzienda'] = codice;
    }
    if (aziendaId != null) {
      payload['aziendaId'] = aziendaId;
    }

    final response = await _client.post(
      uri,
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print("[LOGIN] entro con 200");
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponse.fromJson(json);
    }

    final body = response.body.trim();
    if (response.statusCode == 403) {
      throw AuthException(
        body.isEmpty ? 'Accesso mobile non abilitato' : body,
      );
    }

    throw AuthException(body.isEmpty ? 'Credenziali errate' : body);
  }

  Future<void> logout({required String token}) async {
    final uri = Uri.parse('$baseUrl/api/auth/logout');
    final response = await _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    final body = response.body.trim();
    throw AuthException(body.isEmpty ? 'Logout non riuscito' : body);
  }
}
