import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';

class AuthField extends StatelessWidget {
  final String hintText;

  const AuthField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey[300]!, blurRadius: 4, spreadRadius: 4),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          fillColor: AppTheam.primarywhite,
          filled: true,
        ),
      ),
    );
  }
}
