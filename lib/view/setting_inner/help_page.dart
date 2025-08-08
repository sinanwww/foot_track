import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Help"),
      body: LayoutBuilder(
        builder: (context, co) {
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            children: [
              //how to make a team head
              titel("how to make a team ?"),

              //how to make a team guidelines
              txt(1, 'Tap the "New Team" button.'),
              txt(2, 'Enter your team name, then tap "Next".'),
              txt(3, 'Add at least 11 players to your team.'),
              txt(4, 'Once done, tap "Create Team" to finish.'),
              SizedBox(height: 25),
              //titel of how to make a match
              titel("how to make a match ?"),

              //how to make a match guidelines
              txt(1, 'Make sure you have created at least two teams.'),
              txt(2, 'Tap the "New Match" button.'),
              txt(
                3,
                'Select the maximum lineup size and match duration, then tap "Next".',
              ),
              txt(4, 'Choose the home team, then tap "Confirm".'),
              txt(
                5,
                'Select the players for the home team lineup, then tap "Confirm".',
              ),
              txt(6, 'Choose the away team, then tap "Confirm".'),
              txt(
                7,
                'Select the players for the away team lineup, then tap "Confirm".',
              ),
              txt(
                8,
                "You’ll be taken to the match page — you're ready to start the game!",
              ),
            ],
          );
        },
      ),
    );
  }

  //refactor text
  Widget txt(int orderNumber, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${orderNumber.toString()}.",
            style: Fontstyle(
              color: AppTheam.primaryBlack,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 15),
          SizedBox(
            width: 250,
            child: Text(
              label,
              style: Fontstyle(
                color: AppTheam.primaryBlack,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget titel(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      title,
      style: Fontstyle(
        color: AppTheam.primaryBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
