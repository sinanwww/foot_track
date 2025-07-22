import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/auth_field.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view/nav_controller.dart';
import 'package:get/get.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: ""),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: Fontstyle(
                  color: AppTheam.primaryBlack,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 100),
              AuthField(hintText: "user name"),
              SizedBox(height: 25),
              AuthField(hintText: "password"),
              SizedBox(height: 50),
              AuthButton(
                onClick: () {
                  Get.offAll(() => NavController());
                },
                label: "Signup",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
