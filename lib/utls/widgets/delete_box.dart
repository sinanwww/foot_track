import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class DeleteBox extends StatelessWidget {
  final Function() deleteOnClick;
  final Function()? cancelOnClick;
  final String message;
  const DeleteBox({
    super.key,
    required this.deleteOnClick,
    required this.message,
    this.cancelOnClick,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Fontstyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                dialogBtn(
                  label: "cancel",
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(width: 15),
                dialogBtn(
                  isOutlined: false,
                  label: "Delete",
                  onTap: () {
                    deleteOnClick();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dialogBtn({
    bool isOutlined = true,
    required String label,
    required Function() onTap,
  }) => ElevatedButton(
    onPressed: onTap,
    child: Text(label),
    style: ElevatedButton.styleFrom(
      foregroundColor: isOutlined == true ? Colors.grey[700] : AppColors.white,
      backgroundColor: isOutlined == true ? Colors.grey[300] : Colors.red,
    ),
  );
}
