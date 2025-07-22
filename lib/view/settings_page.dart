import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/logout_popup.dart';
import 'package:foot_track/view/auth/change_password.dart';
import 'package:foot_track/view/setting_inner/help_page.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Scaffold(
        body: Column(
          children: [
            settingBtn(
              icon: Icons.logout,
              label: "Logout",
              onTap:
                  () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LogoutPopup();
                    },
                  ),
            ),

            settingBtn(
              icon: Icons.lock_reset_rounded,
              label: "Change Password",
              onTap: () {
                Get.to(() => ChangePassword());
              },
            ),

            settingBtn(
              icon: Icons.help_center_outlined,
              label: "Help",
              onTap: () {
                Get.to(HelpPage());
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    color: AppTheam.primaryBlack,
                    size: 40,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Dark Mode",
                    style: Fontstyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheam.primaryBlack,
                    ),
                  ),
                  Spacer(),
                  Switch(value: false, onChanged: (value) {}),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget settingBtn({
    required IconData icon,
    required String label,
    required Function()? onTap,
  }) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(icon, color: AppTheam.primaryBlack, size: 40),
              SizedBox(width: 12),
              Text(
                label,
                style: Fontstyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppTheam.primaryBlack,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
      Divider(),
    ],
  );
}
