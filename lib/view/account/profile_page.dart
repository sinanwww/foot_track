import 'package:flutter/material.dart';
import 'package:foot_track/model/user/user_model.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/auth_button.dart';
import 'package:foot_track/utls/widgets/delete_box.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view%20model/user_repo.dart';
import 'package:foot_track/view/account/create_account_page.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Future<void> _handleEditUser(UserModel currentUser) async {
    // Prepopulate controllers with current user data
    _nameController.text = currentUser.name;
    _ageController.text = currentUser.age.toString();
    _mobileController.text = currentUser.mobileNumber;
    _emailController.text = currentUser.email;

    showModalBottomSheet(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        side: BorderSide(color: Theme.of(context).colorScheme.secondary),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 30,
              right: 30,
              top: 20,
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Edit Account",
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
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
                    const SizedBox(height: 20),
                    AuthButton(
                      onClick: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final updatedUser = UserModel(
                              name: _nameController.text.trim(),
                              age: int.parse(_ageController.text.trim()),
                              mobileNumber: _mobileController.text.trim(),
                              email: _emailController.text.trim(),
                            );
                            await _userRepo.saveUser(updatedUser);
                            Get.back(); // Close bottom sheet
                            setState(() {}); // Refresh UI
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Account updated'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error updating account: $e'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                      label: "Save Changes",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Future<void> _handleClearData() async {
    try {
      await _userRepo.deleteUser();
      Get.offAll(() => const CreateAccountPage());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account data cleared'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error clearing data: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Fontstyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder<UserModel?>(
            future: _userRepo.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No account data found'));
              }
              final user = snapshot.data!;
              return FormWrap(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account Details",
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),
                    labelTxt("Name"),
                    Text(
                      user.name,
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                    labelTxt("Age"),
                    Text(
                      user.age.toString(),
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                    labelTxt("Mobile Number"),
                    Text(
                      user.mobileNumber,
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),
                    labelTxt("Email"),
                    Text(
                      user.email,
                      style: Fontstyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleEditUser(user),
                            child: Text("Edit"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => DeleteBox(
                                        deleteOnClick: () => _handleClearData(),
                                        message:
                                            "Are you sure you want to clear all your account data?",
                                      ),
                                ),
                            child: Text("Clear Data"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
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
