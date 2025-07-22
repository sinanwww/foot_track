import 'package:flutter/material.dart';
import 'package:foot_track/utls/widgets/match_card.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE8E8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, cst) {
            int count = 1;
            double ratio = 4 / 1;
            if (cst.maxWidth > 300) {
              ratio = 3 / .8;
            }
            if (cst.maxWidth > 700) {
              count = 2;
            }
            if (cst.maxWidth > 1200) {
              count = 3;
              ratio = 5 / 1.2;
            }
            if (cst.maxWidth > 2400) {
              count = 3;
              ratio = 6 / 1;
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: ratio,
                crossAxisCount: count,
              ),
              itemCount: 10,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) => MatchCard(),
            );
          },
        ),
      ),
    );
  }
}
