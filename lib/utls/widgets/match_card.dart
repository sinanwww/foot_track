import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foot_track/utls/font_style.dart';

class MatchCard extends StatelessWidget {
  final Uint8List? homeTeamLogoPath;
  final Uint8List? awayTeamLogoPath;
  final String displayDate;
  final String homeTeam;
  final int homeScore;
  final String awayTeam;
  final int awayScore;
  final String startTime;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    this.homeTeamLogoPath,
    this.awayTeamLogoPath,
    required this.displayDate,
    required this.homeTeam,
    required this.homeScore,
    required this.awayTeam,
    required this.awayScore,
    required this.startTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 4,

      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(displayDate, style: Fontstyle(fontSize: 10)),
              SizedBox(height: 5),
              cardRow(
                imagePath: homeTeamLogoPath!,
                teamName: homeTeam,
                score: homeScore.toString(),
              ),
              SizedBox(height: 10),
              cardRow(
                imagePath: awayTeamLogoPath!,
                teamName: awayTeam,
                score: awayScore.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget cardRow({
  required Uint8List imagePath,
  required String teamName,
  required String score,
}) => Row(
  children: [
    Image.memory(imagePath, width: 20, fit: BoxFit.fill),
    SizedBox(width: 10),
    Text(teamName),
    Spacer(),
    Text(score),
  ],
);
