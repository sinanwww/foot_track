import 'package:flutter/material.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/new_team/create_team_page.dart';
import 'package:get/get.dart';

class TeamNamePage extends StatelessWidget {
  const TeamNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Make a new team"),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Team Name",
              style: Fontstyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 30),
            TypeField(hintText: "btm FC"),
            SizedBox(height: 30),
            ArrowButton(
              label: "Next",
              onClick: () {
                Get.to(() => CreateTeamPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
