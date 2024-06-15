import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:wikigamenew/bloc/switch_bloc.dart';
import 'package:wikigamenew/style/theme.dart' as Style;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  late SwitchBloc _switchBloc;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _switchBloc = SwitchBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _showGrid() {
    _switchBloc.showGrid();
  }

  void _showList() {
    _switchBloc.showList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20232A),
      appBar: PreferredSize(
          child: Container(), preferredSize: Size.fromHeight(0.0)),
      body: SizedBox.expand(
        child: PageView(
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            Container(
              child: Text("Screen 1"),
            ),
            Container(
              child: Text("Screen 2"),
            ),
            Container(
              child: Text("Screen 3"),
            ),
            Container(
              child: Text("Screen 4"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavyBar(
          containerHeight: 56.0,
          backgroundColor: Style.Colors.backgroundColor,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                activeColor: Color(0xFF010101),
                title: Text(
                  'Discover',
                  style:
                      TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(SimpleLineIcons.game_controller,
                      size: 18.0,
                      color: _currentIndex == 0
                          ? Style.Colors.mainColor
                          : Colors.white),
                )),
            BottomNavyBarItem(
                activeColor: Color(0xFF010101),
                title: Text(
                  'Discover',
                  style:
                      TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(SimpleLineIcons.game_controller,
                      size: 18.0,
                      color: _currentIndex == 0
                          ? Style.Colors.mainColor
                          : Colors.white),
                )),
            BottomNavyBarItem(
                activeColor: Color(0xFF010101),
                title: Text(
                  'Discover',
                  style:
                      TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(SimpleLineIcons.game_controller,
                      size: 18.0,
                      color: _currentIndex == 0
                          ? Style.Colors.mainColor
                          : Colors.white),
                )),
            BottomNavyBarItem(
                activeColor: Color(0xFF010101),
                title: Text(
                  'Discover',
                  style:
                      TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Icon(SimpleLineIcons.game_controller,
                      size: 18.0,
                      color: _currentIndex == 0
                          ? Style.Colors.mainColor
                          : Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}
