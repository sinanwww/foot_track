import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddPhoto extends StatefulWidget {
  final Function(String)? onImageAdded;
  final String? initialImage;
  const AddPhoto({super.key, this.onImageAdded, this.initialImage});

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImage;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onImageAdded!(image.path);
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage:
                _imagePath != null ? FileImage(File(_imagePath!)) : null,
            radius: 70,
            backgroundColor: Colors.grey,
            child:
                _imagePath == null
                    ? Icon(Icons.person, size: 80, color: Colors.grey[200])
                    : null,
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppTheam.primary,
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
