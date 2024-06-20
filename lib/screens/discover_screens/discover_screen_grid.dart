import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:wikigamenew/bloc/get_games_bloc.dart';
import 'package:wikigamenew/elements/error_element.dart';
import 'package:wikigamenew/elements/loader_element.dart';
import 'package:wikigamenew/model/game.dart';
import 'package:wikigamenew/model/game_response.dart';
import 'package:wikigamenew/style/theme.dart' as Style;

class DiscoverScreenGrid extends StatefulWidget {
  const DiscoverScreenGrid({super.key});

  @override
  _DiscoverScreenGridState createState() => _DiscoverScreenGridState();
}

class _DiscoverScreenGridState extends State<DiscoverScreenGrid> {
  @override
  void initState() {
    super.initState();
    getGamesBloc.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getGamesBloc.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
          if (data.error != null && data.error.isNotEmpty) {
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
              children: List.generate(
                games.length,
                (int index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 3,
                    duration: Duration(milliseconds: 370),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
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
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.9),
                                        Colors.black.withOpacity(0.0)
                                      ],
                                      stops: [0.0, 0.05],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20.0,
                                left: 5.0,
                                child: Container(
                                  width: 90.0,
                                  child: Text(
                                    games[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5.0,
                                left: 5.0,
                                child: Row(
                                  children: [
                                    RatingBar(
                                      itemSize: 6.0,
                                      initialRating: games[index].rating / 20,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      ratingWidget: RatingWidget(
                                        full: Icon(
                                          EvaIcons.star,
                                          color: Style.Colors.secondaryColor,
                                        ),
                                        half: Icon(
                                          EvaIcons.star,
                                          color: Style.Colors.secondaryColor,
                                        ),
                                        empty: Icon(
                                          EvaIcons.starOutline,
                                          color: Style.Colors.secondaryColor,
                                        ),
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      (games[index].rating / 20)
                                          .toStringAsFixed(1),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
  }
}
