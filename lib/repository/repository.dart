import 'package:wikigamenew/model/game_response.dart';
import 'package:http/http.dart' as http;

class GameRepository {
  static String mainUrl = 'https://api.igdb.com/v4';
  var gameListUrl = '$mainUrl/games';
  final String apiKey = '<api key>';
}
