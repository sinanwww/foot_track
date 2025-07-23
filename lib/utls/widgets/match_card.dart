import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class MatchCard extends StatelessWidget {
  final String displayDate;
  final String homeTeam;
  final String awayTeam;
  final int homeScroe;
  final int awayScore;
  final Color displayDateColor;

  const MatchCard({
    super.key,
    required this.displayDate,
    required this.awayScore,
    required this.awayTeam,
    required this.homeScroe,
    required this.homeTeam,
    required this.displayDateColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheam.primarywhite,
        boxShadow: [
          BoxShadow(color: Colors.grey[400]!, spreadRadius: 5, blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            displayDate,
            style: Fontstyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: displayDateColor,
            ),
          ),
          Row(
            children: [
              Text(
                homeTeam,
                style: Fontstyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
              Spacer(),
              Text(
                homeScroe.toString(),
                style: Fontstyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Text(
                awayTeam,
                style: Fontstyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
              Spacer(),
              Text(
                awayScore.toString(),
                style: Fontstyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
