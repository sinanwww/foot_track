import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/view/navbar/add_page.dart';
import 'package:foot_track/view/navbar/home_page.dart';
import 'package:foot_track/view/navbar/match_tour_page.dart';
import 'package:foot_track/view/navbar/settings_page.dart';
import 'package:foot_track/view/navbar/teams_players.dart';

class NavController extends StatefulWidget {
  final int? index;
  final int? teamPlayerTabIndex;
  final int? matchTourTabIndex;
  const NavController({
    super.key,
    this.index = 0,
    this.teamPlayerTabIndex = 0,
    this.matchTourTabIndex = 0,
  });

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
        elevation: 5,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        shadowColor: const Color.fromARGB(255, 234, 226, 226),
        indicatorColor: Theme.of(context).colorScheme.secondary,

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

            // match and tournament listing page page
            MatchTourPage(matchTourTabIndex: widget.matchTourTabIndex),

            // add page
            AddPage(),

            // Teams and palyers Tab
            TeamsPlayersTab(teamPlayerTabIndex: widget.teamPlayerTabIndex),

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
    icon:
        currentPageIndex == index
            ? Icon(activeIcon, color: Theme.of(context).colorScheme.secondary)
            : Icon(icon, color: AppColors.secondary),
  );
}
