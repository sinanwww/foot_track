import 'package:flutter/material.dart';
import 'package:foot_track/view%20model/match_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dt() async {
  //   await MatchService().deleteAllMatches();
  // }

  // @override
  // void initState() {
  //   dt();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: SafeArea(
      //   child: LayoutBuilder(
      //     builder: (context, cst) {
      //       int count = 1;
      //       double ratio = 4 / 1;
      //       if (cst.maxWidth > 300) {
      //         ratio = 3 / .8;
      //       }
      //       if (cst.maxWidth > 700) {
      //         count = 2;
      //       }
      //       if (cst.maxWidth > 1200) {
      //         count = 3;
      //         ratio = 5 / 1.2;
      //       }
      //       if (cst.maxWidth > 2400) {
      //         count = 3;
      //         ratio = 6 / 1;
      //       }
      //       return GridView.builder(
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           childAspectRatio: ratio,
      //           crossAxisCount: count,
      //         ),
      //         itemCount: 10,
      //         padding: EdgeInsets.all(10),
      //         itemBuilder:
      //             (context, index) => MatchCard(
      //               displayDateColor: AppTheam.hilight,
      //               displayDate: "Live",
      //               homeTeam: "Manchester City",
      //               awayTeam: "Manchester United",
      //               awayScore: 2,
      //               homeScore: 5,
      //             ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}
