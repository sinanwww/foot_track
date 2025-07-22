import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';

class TypeField extends StatelessWidget {
  final String hintText;
  const TypeField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(decoration: customDecoretion(hintText));
  }
}

InputDecoration customDecoretion(String hintText) => InputDecoration(
  hintText: hintText,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
  fillColor: AppTheam.typeFieldBg,
  filled: true,
);
