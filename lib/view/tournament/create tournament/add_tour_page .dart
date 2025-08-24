import 'package:flutter/material.dart';
import 'package:foot_track/model/tournament/tournament_model.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/match/date_bottem.dart';
import 'package:foot_track/view/tournament/create%20tournament/add_team_page.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTournamentPage extends StatefulWidget {
  const AddTournamentPage({super.key});

  @override
  State<AddTournamentPage> createState() => _AddTournamentPageState();
}

class _AddTournamentPageState extends State<AddTournamentPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameCt = TextEditingController();
  final TextEditingController venueCt = TextEditingController();
  final TextEditingController dateCt = TextEditingController();
  final TournamentService _tournamentService = TournamentService();
  DateTime? selectedDate;

  @override
  void dispose() {
    nameCt.dispose();
    venueCt.dispose();
    dateCt.dispose();
    super.dispose();
  }

  Future<void> _saveTournament() async {
    if (nameCt.text.isEmpty || venueCt.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      final tournament = TournamentModel(
        name: nameCt.text.trim(),
        venue: venueCt.text.trim(),
        date: selectedDate,
        teamKeys: [],
        rounds: [],
      );
      await _tournamentService.createTournament(tournament);
      Get.to(() => AddTeamPage(tournamentKey: tournament.key!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tournament created'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating tournament: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Create Tournament"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FormWrap(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText("Name"),
                  TypeField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Team name cannot be empty';
                      }
                      return null;
                    },
                    hintText: "Tournament name",
                    controller: nameCt,
                  ),
                  labelText("Venue"),
                  TypeField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Team Venue cannot be empty';
                      }
                      return null;
                    },
                    hintText: "Venue",
                    controller: venueCt,
                  ),
                  labelText("Date"),
                  DatePickerBottem(
                    controller: dateCt,
                    onSubmit: (date) {
                      selectedDate = date;
                      dateCt.text = DateFormat('dd-MM-yyyy').format(date);
                    },
                  ),
                  const SizedBox(height: 80),
                  ArrowButton(
                    label: "Next",
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        _saveTournament();
                      }
                      ;
                    },
                  ),
                ],
              ),
            ),
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
        color: Theme.of(context).colorScheme.secondary,
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
    ),
  );
}
