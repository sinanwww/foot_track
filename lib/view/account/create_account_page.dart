import 'package:flutter/material.dart';
import 'package:foot_track/model/user/user_model.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view%20model/user_repo.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:get/get.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final UserRepo _userRepo = UserRepo();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _userRepo.close();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = UserModel(
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          mobileNumber: _mobileController.text.trim(),
          email: _emailController.text.trim(),
        );
        await _userRepo.saveUser(user);
        Get.offAll(() => const NavController());
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating account: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: FormWrap(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Create Account",
                        maxLines: 1,
                        style: Fontstyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    labelTxt("Name"),
                    TypeField(
                      hintText: "user name",
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    labelTxt("Age"),
                    TypeField(
                      hintText: "age",
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your age';
                        }
                        if (int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                    labelTxt("Mobile Number"),
                    TypeField(
                      hintText: "mobile number",
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                          return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                    ),
                    labelTxt("Email"),
                    TypeField(
                      hintText: "example@gmail.com",
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    AuthButton(onClick: _handleSignup, label: "Create Account"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget labelTxt(String label) => Padding(
    padding: const EdgeInsets.only(top: 25, bottom: 10),
    child: Text(
      label,
      style: Fontstyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
