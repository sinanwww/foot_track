import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view/navbar/matches_page.dart';
import 'package:foot_track/view/tournament/tournaments_page.dart';

class MatchTourPage extends StatefulWidget {
  final int? matchTourTabIndex;
  const MatchTourPage({super.key, this.matchTourTabIndex = 0});

  @override
  State<MatchTourPage> createState() => _MatchTourPageState();
}

class _MatchTourPageState extends State<MatchTourPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.matchTourTabIndex!,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            labelStyle: Fontstyle(fontSize: 20, fontWeight: FontWeight.w500),
            tabs: const <Widget>[
              Tab(icon: Text("Match")),
              Tab(icon: Text("Tournament")),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[MatchesPage(), TournamentListPage()],
        ),
      ),
    );
  }
}
