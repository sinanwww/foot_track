import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class ArrowButton extends StatelessWidget {
  final String label;
  final Function() onClick;
  final bool isArrow;
  const ArrowButton({
    super.key,
    required this.label,
    required this.onClick,
    this.isArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Fontstyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              isArrow ? Icons.arrow_forward : Icons.add_rounded,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // fixedSize: Size(400, 50),
      ),
    );
  }
}
