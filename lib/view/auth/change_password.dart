import 'package:flutter/material.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/auth_field.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/view/nav_controller.dart';
import 'package:get/get.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Change Password"),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              AuthField(hintText: "old password"),
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
