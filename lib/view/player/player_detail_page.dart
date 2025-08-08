import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';

class PlayerDetailPage extends StatelessWidget {
  final PlayerModel playerModel;
  const PlayerDetailPage({super.key, required this.playerModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Player Details"),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: FileImage(File(playerModel.imagePath!)),
                ),
                SizedBox(height: 50),
                dtLabel("Player Name", playerModel.name),
                dtLabel("Player date of Birth", playerModel.dateOfBirth),
                dtLabel("Player Position", playerModel.position),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dtLabel(String inicator, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Text(
          inicator + " :",
          style: Fontstyle(
            color: AppTheam.primaryBlack,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 10),
        Text(
          value,
          style: Fontstyle(
            color: AppTheam.primaryBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
