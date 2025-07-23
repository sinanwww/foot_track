import 'package:flutter/material.dart';
import 'package:foot_track/view/navbar/add_page.dart';
import 'package:foot_track/view/navbar/home_page.dart';
import 'package:foot_track/view/navbar/matches_page.dart';
import 'package:foot_track/view/navbar/settings_page.dart';
import 'package:foot_track/view/teams_page.dart';

class NavController extends StatefulWidget {
  final int? index;
  const NavController({super.key, this.index = 0});

  @override
  State<NavController> createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int currentPageIndex = 0;
  @override
  void initState() {
    currentPageIndex = widget.index!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 50,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          //home
          navItem(
            index: 0,
            activeIcon: Icons.home_filled,
            icon: Icons.home_outlined,
          ),
          //match
          navItem(
            index: 1,
            activeIcon: Icons.swap_horizontal_circle,
            icon: Icons.swap_horizontal_circle_outlined,
          ),
          //add
          navItem(
            index: 2,
            activeIcon: Icons.add_circle,
            icon: Icons.add_circle_outline,
          ),
          //team
          navItem(
            index: 3,
            activeIcon: Icons.groups_rounded,
            icon: Icons.groups_2_outlined,
          ),
          //settings
          navItem(
            index: 4,
            activeIcon: Icons.settings,
            icon: Icons.settings_outlined,
          ),
        ],
      ),
      body:
          <Widget>[
            // Home page
            HomePage(),

            // matches page
            MatchesPage(),

            // add page
            AddPage(),

            // Teams page
            TeamsPage(),

            // Teams page
            SettingsPage(),
          ][currentPageIndex],
    );
  }

  Widget navItem({
    required int index,
    required IconData activeIcon,
    required IconData icon,
  }) => IconButton(
    onPressed: () {
      setState(() {
        currentPageIndex = index;
      });
    },
    icon: Icon(currentPageIndex == index ? activeIcon : icon),
  );
}
