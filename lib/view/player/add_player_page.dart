import 'package:flutter/material.dart';
import 'package:foot_track/utls/resp.dart';
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
import 'dart:typed_data';

class AddPlayerPage extends StatefulWidget {
  const AddPlayerPage({super.key});

  @override
  _AddPlayerPageState createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedPosition;
  Uint8List? _imageData;
  final PlayerRepo _playerRepo = PlayerRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Player"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: FormWrap(
                  child: Column(
                    children: [
                      AddPhoto(
                        onImageAdded: (bytes) {
                          setState(() {
                            _imageData = bytes;
                          });
                        },
                      ),
                      const SizedBox(height: 50),
                      TypeField(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a player name';
                          }
                          return null;
                        },
                        hintText: "Player Name",
                        controller: _nameController,
                      ),
                      const SizedBox(height: 30),
                      SelectPositin(
                        onSelectPosition: (value) {
                          setState(() {
                            _selectedPosition = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      DatePickerWidget(
                        controller: _dobController,
                        onSubmit: (date) {
                          String formattedDate = DateFormat(
                            'dd-MM-yyyy',
                          ).format(date);
                          _dobController.text = formattedDate;
                        },
                      ),
                      const SizedBox(height: 50),
                      ArrowButton(
                        isArrow: false,
                        label: "Add Player",
                        onClick: () async {
                          if (_formKey.currentState!.validate() &&
                              _selectedPosition != null) {
                            try {
                              final success = await _playerRepo.addPlayer(
                                name: _nameController.text,
                                position: _selectedPosition!,
                                dateOfBirth: _dobController.text,
                                imageData: _imageData,
                              );
                              if (success) {
                                _nameController.clear();
                                _dobController.clear();
                                setState(() {
                                  _imageData = null;
                                  _selectedPosition = null;
                                });
                                Get.off(
                                  () => NavController(
                                    index: 3,
                                    teamPlayerTabIndex: 1,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Player added'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                throw Exception('Failed to add player');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error adding player: $e'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a position'),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 2),
                              ),
                            );
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

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}
