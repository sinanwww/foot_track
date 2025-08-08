import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';

class TypeField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const TypeField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: customDecoretion(hintText),
    );
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
