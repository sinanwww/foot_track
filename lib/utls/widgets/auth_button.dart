import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class AuthButton extends StatelessWidget {
  final Function() onClick;
  final String label;
  const AuthButton({super.key, required this.onClick, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      child: Text(
        label,
        style: Fontstyle(
          color: AppTheam.primarywhite,
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        fixedSize: Size(400, 50),
        backgroundColor: AppTheam.primary,
      ),
    );
  }
}
