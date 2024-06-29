// lib/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiKey = '26acb9f822bf4b4a8dcecc07bce96b03';
  static const String baseUrl = 'https://api.rawg.io/api';

  Future<List<dynamic>> fetchGames({int page = 1}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/games?key=$apiKey&page=$page'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('Falha ao carregar jogos');
    }
  }

  Future<Map<String, dynamic>> fetchGameDetails(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/games/$id?key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar detalhes do jogo');
    }
  }

  Future<Map<String, dynamic>> fetchGameMedia(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/games/$id/screenshots?key=$apiKey'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar mídia do jogo');
    }
  }
}
