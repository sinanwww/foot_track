import 'package:flutter/material.dart';
import 'package:foot_track/utls/font_style.dart';

class TypeField extends StatefulWidget {
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
  State<TypeField> createState() => _TypeFieldState();
}

class _TypeFieldState extends State<TypeField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Fontstyle(color: Theme.of(context).colorScheme.secondary),
      validator: widget.validator,
      controller: widget.controller,
      decoration: customDecoretion(
        hintText: widget.hintText,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}

InputDecoration customDecoretion({
  required String hintText,
  required Color fillColor,
}) => InputDecoration(
  hintText: hintText,
  hintStyle: Fontstyle(color: Colors.grey[400]),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide.none,
  ),
  fillColor: fillColor,
  filled: true,
);
