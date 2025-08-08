import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view/player/players_page.dart';
import 'package:foot_track/view/team/teams_page.dart';

class TeamsPlayersTab extends StatefulWidget {
  final int? teamPlayerTabIndex;
  const TeamsPlayersTab({super.key, this.teamPlayerTabIndex = 0});

  @override
  State<TeamsPlayersTab> createState() => _TeamsPlayersTabState();
}

class _TeamsPlayersTabState extends State<TeamsPlayersTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.teamPlayerTabIndex!,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppTheam.primary,
            labelColor: AppTheam.primary,
            labelStyle: Fontstyle(fontSize: 20, fontWeight: FontWeight.w500),
            tabs: const <Widget>[
              Tab(icon: Text("Teams")),
              Tab(icon: Text("Players")),
            ],
          ),
        ),
        body: TabBarView(children: <Widget>[TeamsPage(), PlayersPage()]),
      ),
    );
  }
}
