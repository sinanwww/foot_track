import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/type_field.dart';

class AddPalyerSheet extends StatefulWidget {
  const AddPalyerSheet({super.key});

  @override
  State<AddPalyerSheet> createState() => _AddPalyerSheetState();
}

Positions? selectedPosition;

class _AddPalyerSheetState extends State<AddPalyerSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  width: 60,
                  height: 10,
                ),
              ),
              labelText("player name"),
              const TypeField(hintText: "asarp"),

              labelText("player positin"),
              Container(
                decoration: BoxDecoration(
                  color: AppTheam.typeFieldBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButton<Positions>(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  isExpanded: true,
                  style: const TextStyle(color: AppTheam.primaryBlack),
                  hint: const Text("Select position"),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
                  value: selectedPosition,
                  items:
                      Positions.values.map((position) {
                        return DropdownMenuItem<Positions>(
                          value: position,
                          child: Text(position.name),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPosition = value;
                    });
                  },
                ),
              ),

              labelText("jersey number"),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: customDecoretion("10"),
              ),
              const SizedBox(height: 30),
              ArrowButton(
                isArrow: false,
                label: "Add",
                onClick: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelText(String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      label,
      style: Fontstyle(
        color: AppTheam.primaryBlack,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}

enum Positions {
  gk("Goalkeeper"),
  df("Defender"),
  fw("Forward"),
  md("Midfielder");

  final String name;
  const Positions(this.name);
}
