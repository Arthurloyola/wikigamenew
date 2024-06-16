import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wikigamenew/bloc/get_games_bloc.dart';
import 'package:wikigamenew/elements/error_element.dart';
import 'package:wikigamenew/elements/loader_element.dart';
import 'package:wikigamenew/model/game.dart';
import 'package:wikigamenew/model/game_response.dart';

class DiscoverScreenGrid extends StatefulWidget {
  @override
  _DiscoverScreenGridState createState() => _DiscoverScreenGridState();
}

class _DiscoverScreenGridState extends State<DiscoverScreenGrid> {
  @override
  void initState() {
    getGamesBloc.getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGamesBloc.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
          if (data.error != null && data.error!.isNotEmpty) {
            return buildErrorWidget(data.error!);
          }
          return _buildGameGridWidget(data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildGameGridWidget(GameResponse data) {
    List<GameModel> games = data.games;
    if (games.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text("No game to show")],
        ),
      );
    } else
      return AnimationLimiter(
          child: AnimationLimiter(
              child: Padding(
        padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
          children: List.generate(games.length, (int index) {
            return AnimationConfiguration.staggeredGrid(
                position: index,
                columnCount: 3,
                duration: Duration(milliseconds: 370),
                child: ScaleAnimation(
                    child: FadeInAnimation(
                        child: GestureDetector(
                            onTap: () {},
                            child: Stack(children: [
                              Hero(
                                  tag: games[index].id,
                                  child: AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover.imageId}.jpg"),
                                                  fit: BoxFit.cover)))))
                            ])))));
          }),
        ),
      )));
  }
}
