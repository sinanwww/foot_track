import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:flutter/material.dart';

class DatePickerBottem extends StatelessWidget {
  final Function(dynamic)? onSubmit;
  final TextEditingController controller;
  const DatePickerBottem({
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
      onTap: () {
        BottomPicker.date(
          // ignore: deprecated_member_use
          titlePadding: EdgeInsets.only(top: 10),
          buttonSingleColor: AppTheam.primary,
          buttonAlignment: MainAxisAlignment.end,
          dismissable: true,
          dateOrder: DatePickerDateOrder.dmy,
          initialDateTime: DateTime.now(),
          maxDateTime: DateTime(2050),
          minDateTime: DateTime(1900),

          onSubmit: onSubmit,
        ).show(context);
      },
      decoration: customDecoretion("select"),
      controller: controller,
    );
  }
}
