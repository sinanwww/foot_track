import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:get/get.dart';

class DeleteBox extends StatelessWidget {
  final Function() deleteOnClick;
  const DeleteBox({super.key, required this.deleteOnClick});

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
            Text(
              "Delete",
              style: Fontstyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dialogBtn(
                  label: "cancel",
                  onTap: () {
                    Get.back();
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
      fixedSize: Size(100, 50),

      side: BorderSide(
        color: isOutlined == true ? AppTheam.primary : Colors.red,
      ),
      foregroundColor:
          isOutlined == true ? AppTheam.primary : AppTheam.primarywhite,
      backgroundColor: isOutlined == true ? AppTheam.primarywhite : Colors.red,
    ),
  );
}
