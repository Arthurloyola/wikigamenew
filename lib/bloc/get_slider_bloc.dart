import 'package:wikigamenew/model/game_response.dart';
import 'package:wikigamenew/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSliderBloc {
  final GameRepository _repository = GameRepository();
  final BehaviorSubject<GameResponse> _subject =
      BehaviorSubject<GameResponse>();

  getSlider() async {
    GameResponse response = await _repository.getSlider();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<GameResponse> get subject => _subject;
}

final getSliderBloc = GetSliderBloc();
