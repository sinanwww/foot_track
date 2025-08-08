import 'package:flutter/material.dart';
import 'package:foot_track/model/player/player_model.dart';
import 'package:foot_track/utls/widgets/arrow_button.dart';
import 'package:foot_track/utls/widgets/costom_appbar.dart';
import 'package:foot_track/utls/widgets/type_field.dart';
import 'package:foot_track/view/navbar/nav_controller.dart';
import 'package:foot_track/view/player/widgets/add_photo.dart';
import 'package:foot_track/view/player/widgets/date_picker.dart';
import 'package:foot_track/view/player/widgets/select_positin.dart';
import 'package:foot_track/view%20model/player.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key});

  @override
  State<AddPlayerPage> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  String? imagePath;
  String? selectedPositin;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameCt = TextEditingController();
  TextEditingController dobCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Player"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // add photo widget
                AddPhoto(
                  onImageAdded: (path) {
                    imagePath = path;
                  },
                ),
                SizedBox(height: 50),
                // input name
                TypeField(
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a team name';
                    }
                    return null;
                  },
                  hintText: "name",
                  controller: nameCt,
                ),

                SizedBox(height: 30),

                //for select position
                SelectPositin(
                  onSelectPosition: (value) {
                    selectedPositin = value;
                  },
                ),
                SizedBox(height: 30),

                //date of birth picker
                DatePickerWidget(
                  controller: dobCt,
                  onSubmit: (index) {
                    String formattedDate = DateFormat(
                      'dd-MM-yyyy',
                    ).format(index);
                    dobCt.text = formattedDate;
                  },
                ),
                SizedBox(height: 50),
                ArrowButton(
                  isArrow: false,
                  label: "Add Player",
                  onClick: () async {
                    if (_formKey.currentState!.validate()) {
                      final player = PlayerModel(
                        name: nameCt.text,
                        imagePath: imagePath,
                        dateOfBirth: dobCt.text,
                        position: selectedPositin!,
                      );
                      var isSucsess = await PlayerRepo().addPlayer(player);

                      if (isSucsess) {
                        nameCt.clear();
                        imagePath = null;
                        dobCt.clear();
                        selectedPositin = null;
                        Get.off(
                          () => NavController(index: 3, teamPlayerTabIndex: 1),
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
    );
  }
}
