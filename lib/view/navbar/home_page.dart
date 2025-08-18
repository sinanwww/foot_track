import 'package:flutter/material.dart';
import 'package:foot_track/view/home/carousel_widget.dart';
import 'package:foot_track/view/home/matches_list.dart';
import 'package:foot_track/view/home/tournament_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            // sliding add widgets
            CarouselWidget(),
            // today & upcoming tournaments
            TournamentList(),

            //
            MatchesList(),
          ],
        ),
      ),
    );
  }
}
