import 'package:flutter/material.dart';
import 'package:foot_track/model/tournament/round_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/match/date_bottem.dart';
import 'package:foot_track/view%20model/tournament_service.dart';
import 'package:foot_track/view/tournament/tournament%20manage/tour_manage_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddRoundPage extends StatefulWidget {
  final String tournamentKey;
  final int? roundIndex;
  final RoundModel? round;

  const AddRoundPage({
    super.key,
    required this.tournamentKey,
    this.roundIndex,
    this.round,
  });

  @override
  State<AddRoundPage> createState() => _AddRoundPageState();
}

class _AddRoundPageState extends State<AddRoundPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController nameCt = TextEditingController();
  final TextEditingController descriptionCt = TextEditingController();
  final TextEditingController dateCt = TextEditingController();
  final TournamentService _tournamentService = TournamentService();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.round != null) {
      nameCt.text = widget.round!.name ?? '';
      descriptionCt.text = widget.round!.description ?? '';
      selectedDate = widget.round!.date;
      if (selectedDate != null) {
        dateCt.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
      }
    }
  }

  Future<void> _saveRound() async {
    if (nameCt.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill name and date'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      final round = RoundModel(
        name: nameCt.text.trim(),
        date: selectedDate,
        description: descriptionCt.text.trim(),
        matchKeys: widget.round?.matchKeys ?? [],
      );
      if (widget.roundIndex != null) {
        await _tournamentService.updateRound(
          widget.tournamentKey,
          widget.roundIndex!,
          round,
        );
      } else {
        await _tournamentService.addRound(widget.tournamentKey, round);
      }
      Get.off(() => TourManagePage(tournamentKey: widget.tournamentKey));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Round saved'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving round: $e'),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 200, left: 20, right: 20),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameCt.dispose();
    descriptionCt.dispose();
    dateCt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: widget.roundIndex != null ? "Edit Round" : "Add Round",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FormWrap(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelText("Round Name"),
                  TypeField(
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Round name is required';
                      }
                      return null;
                    },
                    hintText: "Round name",
                    controller: nameCt,
                  ),
                  labelText("Date"),
                  DatePickerBottem(
                    controller: dateCt,
                    onSubmit: (date) {
                      selectedDate = date;
                      dateCt.text = DateFormat('dd-MM-yyyy').format(date);
                    },
                  ),
                  labelText("Description"),
                  TypeField(hintText: "Description", controller: descriptionCt),
                  const SizedBox(height: 80),
                  ArrowButton(
                    label: "Save",
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        _saveRound();
                      }
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
        color: AppColors.black,
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
    ),
  );
}
