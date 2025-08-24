import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final Function(dynamic)? onSubmit;
  final TextEditingController controller;
  const DatePickerWidget({
    super.key,
    required this.onSubmit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your Date of Birth';
        }
        return null;
      },
      readOnly: true,
      style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      onTap: () {
        BottomPicker.date(
          // ignore: deprecated_member_use
          titlePadding: EdgeInsets.only(top: 10),
          buttonSingleColor: AppColors.primary,
          buttonAlignment: MainAxisAlignment.end,
          dismissable: true,
          dateOrder: DatePickerDateOrder.dmy,
          initialDateTime: DateTime.now(),
          maxDateTime: DateTime.now(),
          minDateTime: DateTime(1980),
          backgroundColor: Theme.of(context).colorScheme.surface,
          // ignore: deprecated_member_use
          closeIconColor: Theme.of(context).colorScheme.secondary,
          // ignore: deprecated_member_use
          pickerTextStyle: Fontstyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.secondary,
          ),

          onSubmit: onSubmit,
        ).show(context);
      },
      decoration: customDecoretion(
        fillColor: Theme.of(context).colorScheme.surface,
        hintText: "Date of Birth",
      ),
      controller: controller,
    );
  }
}
