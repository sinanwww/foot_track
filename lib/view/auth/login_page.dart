import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/auth_field.dart';
import 'package:foot_track/view/auth/auth_validate.dart';
import 'package:foot_track/view/auth/signup_page.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? userNameCt = TextEditingController();
  TextEditingController? passwordCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: Fontstyle(
                    color: AppTheam.primaryBlack,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 100),
                AuthField(
                  validator: (val) {
                    return AuthValidate().userNameValidate(val);
                  },
                  controller: userNameCt,
                  hintText: "user name",
                ),
                SizedBox(height: 25),
                AuthField(
                  validator: (val) {
                    return AuthValidate().passwordValidate(val);
                  },
                  controller: passwordCt,
                  hintText: "password",
                ),
                SizedBox(height: 50),
                AuthButton(
                  onClick: () {
                    if (_formKey.currentState!.validate()) {
                      Get.offAll(() => NavController());
                    }
                  },
                  label: "Login",
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => SignupPage());
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "never here? ",
                      style: Fontstyle(
                        color: AppTheam.secondoryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                          text: "create an account",
                          style: Fontstyle(color: AppTheam.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
