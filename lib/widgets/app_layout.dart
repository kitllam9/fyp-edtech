import 'package:flutter/material.dart';
import 'package:fyp_edtech/pages/achievement_page.dart';
import 'package:fyp_edtech/pages/home_page.dart';
import 'package:fyp_edtech/pages/profile_page.dart';
import 'package:fyp_edtech/pages/search_page.dart';
import 'package:fyp_edtech/pages/stats_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class AppLayout extends StatefulWidget {
  final int index;
  const AppLayout({
    super.key,
    required this.index,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int? _index;

  List<Widget> page = [
    HomePage(),
    SearchPage(),
    AchievementPage(),
    StatsPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    _index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color.fromARGB(255, 15, 15, 15),
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Color(0xFFB1B1B1),
          selectedItemColor: Colors.white,
          iconSize: 32,
          currentIndex: _index!,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Symbols.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Symbols.search,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Symbols.workspace_premium,
              ),
              label: 'Achievement',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Symbols.bar_chart,
              ),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Symbols.person,
              ),
              label: 'Profile',
            ),
          ],
          onTap: (value) {
            setState(() {
              _index = value;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: page[_index!],
        ),
      ),
    );
  }
}
