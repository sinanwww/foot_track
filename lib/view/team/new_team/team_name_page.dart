import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foot_track/model/team/team_model.dart';
import 'package:foot_track/utls/resp.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/team/new_team/create_team_page.dart';
import 'package:foot_track/view/team/widget/add_logo.dart';
import 'package:foot_track/view%20model/team_repo.dart';
import 'package:get/get.dart';

class TeamNamePage extends StatefulWidget {
  const TeamNamePage({super.key});

  @override
  State<TeamNamePage> createState() => _TeamNamePageState();
}

class _TeamNamePageState extends State<TeamNamePage> {
  final TextEditingController teamNameCt = TextEditingController();
  Uint8List? image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    teamNameCt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: "Make a new team"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FormWrap(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add logo
                  AddLogo(
                    onImageSelected: (path) {
                      setState(() {
                        image = path;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  const Center(
                    child: Column(
                      children: [
                        Text(
                          "Add Team Logo",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Team Name",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 30),
                  TypeField(
                    hintText: "btm FC",
                    controller: teamNameCt,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a team name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),
                  ArrowButton(
                    label: "Next",
                    onClick: () async {
                      if (_formKey.currentState!.validate()) {
                        final teamModel = TeamModel(
                          name: teamNameCt.text.trim(),
                          logoImage: image,
                          teamPlayer: {}, // Initialize empty teamPlayer map
                        );
                        final key = await TeamRepo().addTeam(teamModel);
                        if (key != null) {
                          Get.to(() => CreateTeam(teamKey: key));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to create team'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
