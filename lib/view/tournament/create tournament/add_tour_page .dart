import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/match/date_bottem.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_team_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTournamentPage extends StatefulWidget {
  const AddTournamentPage({super.key});

  @override
  State<AddTournamentPage> createState() => _AddTournamentPageState();
}

class _AddTournamentPageState extends State<AddTournamentPage> {
  TextEditingController? nameCt = TextEditingController();
  TextEditingController? veneuCt = TextEditingController();
  TextEditingController? dateCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Create Tournament"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              labelText("Name"),
              TypeField(hintText: "name ", controller: nameCt),
              labelText("Venue"),
              TypeField(hintText: "venue ", controller: veneuCt),
              labelText("Date"),
              DatePickerBottem(
                controller: dateCt!,
                onSubmit: (index) {
                  String date = index;
                  String formattedDate = DateFormat('dd-MM-yyyy').format(index);
                  dateCt!.text = formattedDate;
                },
              ),
              SizedBox(height: 80),
              ArrowButton(
                label: "Next",
                onClick: () {
                  Get.to(() => AddTeamPage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelText(String label) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 10),
    child: Text(
      label,
      style: Fontstyle(
        color: AppTheam.primaryBlack,
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
    ),
  );
}
