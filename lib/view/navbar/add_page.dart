import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/view/new_match.dart/select_page.dart';
import 'package:foot_track/view/new_team/team_name_page.dart';
import 'package:get/get.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              addButton(
                label: "Add New Team",
                onClick: () => Get.to(() => TeamNamePage()),
              ),
              SizedBox(height: 30),
              addButton(
                label: "Add New Match",

                onClick: () {
                  Get.to(() => SelectPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget addButton({required String label, required Function() onClick}) =>
    ElevatedButton(
      onPressed: onClick,

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Fontstyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Icon(Icons.add_rounded, color: Colors.white, size: 30),
        ],
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheam.primary,
        foregroundColor: Colors.white,
        fixedSize: Size(250, 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
