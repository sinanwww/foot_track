import 'package:flutter/material.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view/settings/help_inner_page.dart';
import 'package:get/get.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Help"),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 30),
        itemCount: helpMap.length,
        itemBuilder: (context, index) {
          final key = helpMap.keys.elementAt(index);
          final guidelines = helpMap[key];
          return settingBtn(
            label: key,
            onTap: () {
              Get.to(
                () => HelpInnerPage(title: key, guidlinesList: guidelines!),
              );
            },
          );
        },
      ),
    );
  }

  Widget settingBtn({required String label, required Function()? onTap}) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            child: InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Text(
                    label,
                    style: Fontstyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey),
        ],
      );
}

Map<String, List<String>> helpMap = {
  "How to Add Player": [
    "Navigate to the 'Teams' section from the main menu.",
    "Select an existing team or create a new team to add a player to.",
    "Tap the 'Add Player' button or icon (usually a '+' symbol).",
    "Enter the player's details, such as name and jersey number, in the provided fields.",
    "Tap 'Save' or 'Add' to confirm. The player will now be listed in the team's roster.",
    "Ensure the player is not already in another team to avoid conflicts.",
  ],
  "How to Add Team": [
    "Go to the 'Tournaments' tab via the navigation bar.",
    "Select a tournament or tap 'Create Tournament' to start a new one.",
    "In the tournament management page, find the 'Teams' section and tap the '+' icon.",
    "Choose a team from the dropdown list of available teams or create a new one.",
    "If creating a new team, enter details like team name and logo (optional).",
    "Tap 'Add' or 'Save' to include the team in the tournament.",
  ],
  "How to Add Match": [
    "Navigate to the 'Tournaments' tab and select a tournament.",
    "In the tournament management page, locate the 'Rounds' section.",
    "Choose an existing round or tap 'Add Round' to create a new one.",
    "Inside the round, tap 'Add Match' to open the match configuration page.",
    "Select the home and away teams from the dropdown menus.",
    "Choose the required number of players for each team’s lineup (e.g., maxLineup players).",
    "Optionally, select bench players for each team.",
    "Tap 'Create Match' to save. The match will appear in the selected round.",
  ],
  "How to Add Tournament": [
    "From the main menu, go to the 'Tournaments' tab.",
    "Tap the 'Create Tournament' button (usually a '+' icon or 'Add' button).",
    "Enter the tournament details, such as name, venue, and date, in the provided fields.",
    "Optionally, add a description to provide more context about the tournament.",
    "Tap 'Save' or 'Create' to add the tournament.",
    "After creation, add teams and rounds to the tournament from the management page.",
  ],
};
