import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/workout_remoto.dart';
import '../utils/api_config.dart';
import '../utils/auth_exception.dart';

class WorkoutsService {
  WorkoutsService({required this.token, String? baseUrl})
      : _baseUrl = (baseUrl ?? apiBaseUrl).replaceAll(RegExp(r'/$'), '');

  final String token;
  final String _baseUrl;

  Future<List<WorkoutSessioneRemota>> getStorico() async {
    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/workouts'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list
          .map((e) =>
              WorkoutSessioneRemota.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (response.statusCode == 401) throw const UnauthorizedException();
    throw Exception('Errore storico allenamenti: ${response.statusCode}');
  }
}
