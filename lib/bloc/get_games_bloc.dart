import 'package:wikigamenew/model/game_response.dart';
import 'package:wikigamenew/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetGamesBloc {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getGames() async {
    GameResponse response = await _repository.getGames();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getGamesBloc = GetGamesBloc();
