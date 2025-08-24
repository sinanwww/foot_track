import 'package:flutter/material.dart';
import 'package:foot_track/view/account/profile_page.dart';
import 'package:foot_track/view/settings/about_page.dart';
import 'package:foot_track/view/settings/help_page.dart';
import 'package:foot_track/view/settings/privecy_policy_page.dart';
import 'package:foot_track/view/settings/terms_page.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(30),
        itemCount: 5,
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return setinngsBtn(
                label: "Help",
                icon: Icons.help,
                onTap: () {
                  Get.to(() => HelpPage());
                },
              );
            case 1:
              return setinngsBtn(
                label: "About",
                icon: Icons.info,
                onTap: () {
                  Get.to(() => const AboutPage());
                },
              );
            case 2:
              return setinngsBtn(
                label: "Privacy Policy",
                icon: Icons.shield,
                onTap: () {
                  Get.to(() => const PrivacyPolicyPage());
                },
              );
            case 3:
              return setinngsBtn(
                label: "Terms & Conditions",
                icon: Icons.description_rounded,
                onTap: () {
                  Get.to(() => const TermsAndConditionsPage());
                },
              );
            case 4:
              return setinngsBtn(
                label: "Profile",
                icon: Icons.person,
                onTap: () {
                  Get.to(() => const ProfilePage());
                },
              );

            default:
              return const SizedBox.shrink();
          }
        },
        separatorBuilder:
            (context, index) => Divider(
              color: const Color.fromARGB(255, 210, 189, 189),
              thickness: 1,
              height: 20,
            ),
      ),
    );
  }

  Widget setinngsBtn({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          const Spacer(),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    ),
  );
}
