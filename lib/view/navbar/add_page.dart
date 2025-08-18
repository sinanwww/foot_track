import 'package:flutter/material.dart';
import 'package:foot_track/view/match/select_page.dart';
import 'package:foot_track/view/player/add_player_page.dart';
import 'package:foot_track/view/team/new_team/add_new_button.dart';
import 'package:foot_track/view/team/new_team/team_name_page.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_tour_page%20.dart';
import 'package:get/get.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, cst) {
            final crossAxisCount = cst.maxWidth < 1024 ? 1 : 2;
            return Center(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                padding: EdgeInsets.all(30),
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 2,
                children: [
                  AddNewButton(
                    image: "assets/image/player.png",
                    label: "Add New Player",
                    onClick: () {
                      Get.to(() => AddPlayerPage());
                    },
                  ),
                  AddNewButton(
                    image: "assets/image/team.png",
                    label: "Add New Team",
                    onClick: () => Get.to(() => TeamNamePage()),
                  ),
                  AddNewButton(
                    image: "assets/image/match.jpg",
                    label: "Add New Match",
                    onClick: () => Get.to(() => SelectPage()),
                  ),
                  AddNewButton(
                    image: "assets/image/tour.jpg",
                    label: "Add New Tournament",
                    onClick: () {
                      Get.to(() => AddTournamentPage());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
