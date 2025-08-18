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
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      readOnly: true,
      onTap: () async {
        final initialTime = TimeOfDay.now();
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                  surface: Theme.of(context).colorScheme.surface,
                  onSurface: Theme.of(context).colorScheme.secondary,
                ),
                dialogBackgroundColor: Theme.of(context).colorScheme.surface,
                buttonTheme: const ButtonThemeData(
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
      decoration: customDecoretion(
        hintText: "Select Time",
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      controller: controller,
    );
  }
}
