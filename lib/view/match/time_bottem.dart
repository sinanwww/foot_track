import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/type_field.dart';

class TimePickerBottom extends StatelessWidget {
  final Function(TimeOfDay)? onSubmit;
  final TextEditingController controller;
  
  const TimePickerBottom({
    super.key,
    required this.onSubmit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a time';
        }
        return null;
      },
      readOnly: true,
      onTap: () async {
        final initialTime = TimeOfDay.now();
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppTheam.primary, // Set your theme color
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        
        if (pickedTime != null) {
          final formattedTime = pickedTime.format(context);
          controller.text = formattedTime;
          if (onSubmit != null) {
            onSubmit!(pickedTime);
          }
        }
      },
      decoration: customDecoretion("Select Time"),
      controller: controller,
    );
  }
}