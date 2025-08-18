import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class AddPhoto extends StatefulWidget {
  final Function(Uint8List?)? onImageAdded;
  final Uint8List? initialImage;
  const AddPhoto({super.key, this.onImageAdded, this.initialImage});

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageData = widget.initialImage;
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageData = bytes;
        });
        widget.onImageAdded?.call(bytes);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: _imageData != null ? MemoryImage(_imageData!) : null,
            radius: 70,
            backgroundColor: Colors.grey,
            child: _imageData == null
                ? Icon(Icons.person, size: 80, color: Colors.grey[200])
                : null,
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add, color: AppColors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}