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
    _pageController.dispose();
    super.dispose();
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
      backgroundColor: const Color(0xFF20232A),
      appBar: PreferredSize(
          child: Container(), preferredSize: const Size.fromHeight(0.0)),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: const [
            Center(
              child: Text("Screen 1"),
            ),
            Center(
              child: Text("Screen 2"),
            ),
            Center(
              child: Text("Screen 3"),
            ),
            Center(
              child: Text("Screen 4"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        containerHeight: 56.0,
        backgroundColor: Style.Colors.backgroundColor,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              activeColor: const Color(0xFF010101),
              title: Text(
                'Discover',
                style: TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(SimpleLineIcons.game_controller,
                    size: 18.0,
                    color: _currentIndex == 0
                        ? Style.Colors.mainColor
                        : Colors.white),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFF010101),
              title: Text(
                'Search',
                style: TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(SimpleLineIcons.magnifier,
                    size: 18.0,
                    color: _currentIndex == 1
                        ? Style.Colors.mainColor
                        : Colors.white),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFF010101),
              title: Text(
                'Consoles',
                style: TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(SimpleLineIcons.layers,
                    size: 18.0,
                    color: _currentIndex == 2
                        ? Style.Colors.mainColor
                        : Colors.white),
              )),
          BottomNavyBarItem(
              activeColor: const Color(0xFF010101),
              title: Text(
                'Profile',
                style: TextStyle(color: Style.Colors.mainColor, fontSize: 13.0),
              ),
              icon: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Icon(SimpleLineIcons.user,
                    size: 18.0,
                    color: _currentIndex == 3
                        ? Style.Colors.mainColor
                        : Colors.white),
              )),
        ],
      ),
    );
  }
}
