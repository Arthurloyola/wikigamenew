import 'package:wikigamenew/model/game_models/cover.dart';
import 'package:wikigamenew/model/game_models/genre.dart';
import 'package:wikigamenew/model/game_models/mode.dart';
import 'package:wikigamenew/model/game_models/player_perspective.dart';
import 'package:wikigamenew/model/game_models/screenshot.dart';
import 'package:wikigamenew/model/game_models/video.dart';

class GameModel {
  final int id;
  final CoverModel? cover;
  final int createdAt;
  final int firstRelease;
  final List<ModeModel> modes;
  final List<GenreModel> genres;
  final List<PlayerPerspectiveModel> perspectives;
  final double popuparity;
  final List<ScreenshotModel> screenshots;
  final String summary;
  final List<VideoModel> videos;
  final double rating;
  final String name;

  GameModel(
      this.id,
      this.cover,
      this.createdAt,
      this.firstRelease,
      this.modes,
      this.genres,
      this.perspectives,
      this.popuparity,
      this.screenshots,
      this.summary,
      this.videos,
      this.rating,
      this.name);

  GameModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        cover =
            json["cover"] == null ? null : CoverModel.fromJson(json["cover"]),
        createdAt = json["created_at"],
        firstRelease = json["first_release_date"],
        modes = (json["game_modes"] as List?)
                ?.map((i) => ModeModel.fromJson(i))
                .toList() ??
            [],
        genres = (json["genres"] as List?)
                ?.map((i) => GenreModel.fromJson(i))
                .toList() ??
            [],
        perspectives = (json["player_perspectives"] as List?)
                ?.map((i) => PlayerPerspectiveModel.fromJson(i))
                .toList() ??
            [],
        popuparity = json["popularity"] ?? 0.0,
        screenshots = (json["screenshots"] as List?)
                ?.map((i) => ScreenshotModel.fromJson(i))
                .toList() ??
            [],
        summary = json["summary"] ?? '',
        videos = (json["videos"] as List?)
                ?.map((i) => VideoModel.fromJson(i))
                .toList() ??
            [],
        rating = json["rating"] ?? 0.0,
        name = json["name"] ?? '';
}
