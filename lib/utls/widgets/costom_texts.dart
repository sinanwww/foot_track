import 'package:flutter/material.dart' show FontWeight, Text, Widget;
import 'package:foot_track/utls/app_theam.dart' show AppColors;
import 'package:foot_track/utls/font_style.dart';

class CostomTexts {
  Widget txt(String txt) => Text(
    txt,
    style: Fontstyle(
      color: AppColors.black,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}
