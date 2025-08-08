import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddLogo extends StatefulWidget {
  final Function(String?)? onImageSelected;
  const AddLogo({super.key, this.onImageSelected});

  @override
  _AddLogoState createState() => _AddLogoState();
}

class _AddLogoState extends State<AddLogo> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      widget.onImageSelected?.call(_imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 150,
            width: 150,
            child:
                _imagePath == null
                    ? Image.asset("assets/icon/logo.png", color: Colors.grey)
                    : Image.file(File(_imagePath!)),
          ),

          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppTheam.primary,
                child: Icon(Icons.upload, color: AppTheam.primarywhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
