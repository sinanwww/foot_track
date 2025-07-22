import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/add_palyer_sheet.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view/nav_controller.dart';
import 'package:get/get.dart';

class CreateTeamPage extends StatelessWidget {
  const CreateTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Team Name"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: ArrowButton(
              isArrow: false,
              label: "Add Player",
              onClick:
                  () => showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return AddPalyerSheet();
                    },
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              padding: EdgeInsets.all(10),
              shrinkWrap: true,

              itemBuilder:
                  (context, index) => Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppTheam.primarywhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          "10",
                          style: Fontstyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      title: Text(
                        "Asarp",
                        style: Fontstyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text("Forward"),
                    ),
                  ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(25),
        child: AuthButton(
          onClick: () {
            Get.to(() => NavController(index: 3));
          },
          label: "Create",
        ),
      ),
    );
  }
}
