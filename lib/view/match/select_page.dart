import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view/match/date_bottem.dart';
import 'package:foot_track/view/match/match_creation/home/select_home_page.dart';
import 'package:foot_track/view/match/time_bottem.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  int? selectedLineup;
  DateTime? date = DateTime.now();
  DateTime? startTime;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController dateCt = TextEditingController();
  final TextEditingController timeCt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Select"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: FormWrap(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelTxt("Select Max Lineup"),
                    Row(
                      children:
                          maxLinup.entries.map((entry) {
                            final bool isSelected =
                                entry.value == selectedLineup;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedLineup = entry.value;
                                });
                              },
                              child: Container(
                                width: 70,
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : const Color.fromARGB(
                                            255,
                                            197,
                                            185,
                                            185,
                                          ),
                                ),
                                child: Center(
                                  child: Text(
                                    entry.key,
                                    style: Fontstyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                255,
                                                58,
                                                55,
                                                55,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                    labelTxt("Select Date"),
                    DatePickerBottem(
                      controller: dateCt,
                      onSubmit: (selectedDate) {
                        date = selectedDate;
                        String formattedDate = DateFormat(
                          'dd-MM-yyyy',
                        ).format(selectedDate);
                        dateCt.text = formattedDate;
                      },
                    ),
                    labelTxt("Select Time"),
                    TimePickerBottom(
                      controller: timeCt,
                      onSubmit: (selectedTime) {
                        // Convert TimeOfDay to DateTime
                        final now = DateTime.now();
                        startTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );
                        String formattedTime = selectedTime.format(context);
                        timeCt.text = formattedTime;
                      },
                    ),
                    SizedBox(height: 50),
                    ArrowButton(
                      label: "Next",
                      onClick: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedLineup == null) {
                            Get.snackbar(
                              'Error',
                              'Please select a lineup formation',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              margin: const EdgeInsets.only(
                                bottom: 200,
                                left: 20,
                                right: 20,
                              ),
                            );
                          } else {
                            Get.to(
                              () => SelectHomeTeamPage(
                                maxLinup: selectedLineup!,
                                date: date,
                                startTime: startTime,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, int> maxLinup = {"11s": 11, "9s": 9, "7s": 7, "5s": 5};

  Widget labelTxt(String label) => Padding(
    padding: const EdgeInsets.only(top: 30, bottom: 10),
    child: Text(
      label,
      style: Fontstyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
