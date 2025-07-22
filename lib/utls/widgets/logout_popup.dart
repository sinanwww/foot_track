import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view/auth/login_page.dart';
import 'package:get/get.dart';

class LogoutPopup extends StatelessWidget {
  const LogoutPopup({super.key});

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
              "Logout",
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
                  label: "logout",
                  onTap: () {
                    Get.offAll(() => LoginPage());
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

      side: BorderSide(color: AppTheam.primary),
      foregroundColor:
          isOutlined == true ? AppTheam.primary : AppTheam.primarywhite,
      backgroundColor:
          isOutlined == true ? AppTheam.primarywhite : AppTheam.primary,
    ),
  );
}
