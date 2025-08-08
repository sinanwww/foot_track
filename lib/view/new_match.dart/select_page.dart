import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? selectedLineup;

  final TextEditingController _durationController = TextEditingController();
  int _secondsElapsed = 0;
  //in minutes
  int _maxDuration = 90;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Select"),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Max Linup",
                  style: Fontstyle(
                    color: AppTheam.primaryBlack,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children:
                      maxLinup.map((e) {
                        final bool isSelected = e == selectedLineup;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedLineup = e;
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
                                      ? AppTheam.primary
                                      : const Color.fromARGB(
                                        255,
                                        197,
                                        185,
                                        185,
                                      ),
                            ),
                            child: Center(
                              child: Text(
                                e,
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
                SizedBox(height: 40),
                Text(
                  "Select Duration in Minutes",
                  style: Fontstyle(
                    color: AppTheam.primaryBlack,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onTap: _setMaxDuration,
                  decoration: customDecoretion("90"),
                ),

                SizedBox(height: 50),

                ArrowButton(label: "Next", onClick: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setMaxDuration() {
    final newDuration = int.tryParse(_durationController.text);
    if (newDuration != null && newDuration > 0) {
      setState(() {
        _maxDuration = newDuration;
        if (_secondsElapsed > _maxDuration) {
          _secondsElapsed = _maxDuration;
        }
      });
    }
  }

  List<String> maxLinup = ["11s", "9s", "7s", "5s"];
}
