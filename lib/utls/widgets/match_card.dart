import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/mm/yyyy').format(now);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheam.primarywhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formattedDate,
            style: Fontstyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheam.secondoryText,
            ),
          ),
          Row(
            children: [
              Text(
                "barcelona",
                style: Fontstyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
              Spacer(),
              Text(
                "5",
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
                "real madrid",
                style: Fontstyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppTheam.primaryBlack,
                ),
              ),
              Spacer(),
              Text(
                "0",
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
