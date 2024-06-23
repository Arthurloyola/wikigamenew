import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:wikigamenew/bloc/get_games_bloc.dart';
import 'package:wikigamenew/bloc/get_slider_bloc.dart';
import 'package:wikigamenew/elements/error_element.dart';
import 'package:wikigamenew/elements/loader_element.dart';
import 'package:wikigamenew/model/game.dart';
import 'package:wikigamenew/model/game_response.dart';
import 'package:wikigamenew/style/theme.dart' as Style;

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  @override
  void initState() {
    getSliderBloc.getSlider(48);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data!;
          if (snapshot.data?.error != null && snapshot.data!.error.length > 0) {
            return buildErrorWidget(data.error);
          }
          return _buildHomeSliderWidget(data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHomeSliderWidget(GameResponse data) {
    List<GameModel> games = data.games;
    return Container(
      height: 180.0,
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        indicatorSpace: 8.0,
        padding: EdgeInsets.all(5.0),
        indicatorColor: Style.Colors.mainColor,
        indicatorSelectorColor: Style.Colors.secondaryColor,
        shape: IndicatorShape.circle(size: 5.0),
        length: games.take(5).length,
        child: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          itemCount: games.take(5).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  Hero(
                    tag: games[index].id,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  "https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${games[index].screenshots[0].imageId}.jpg")),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                          0.0,
                          0.9
                        ],
                            colors: [
                          Color(0xFF20232A).withOpacity(1.0),
                          Style.Colors.backgroundColor.withOpacity(0.0)
                        ])),
                  ),
                  Positioned(
                      left: 10.0,
                      bottom: 0.0,
                      child: Container(
                        height: 90.0,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover?.imageId}.jpg"),
                                )),
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 30.0,
                    left: 80.0,
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [],
                        )),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
