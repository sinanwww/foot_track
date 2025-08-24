import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:image_picker/image_picker.dart';

class AddLogo extends StatefulWidget {
  final Function(Uint8List?)? onImageSelected;
  const AddLogo({super.key, this.onImageSelected});

  @override
  _AddLogoState createState() => _AddLogoState();
}

class _AddLogoState extends State<AddLogo> {
  Uint8List? _imageData;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageData = bytes;
        });
        widget.onImageSelected?.call(bytes);
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
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 150,
            width: 150,
            child:
                _imageData == null
                    ? Image.asset(
                      "assets/icon/logo.png",
                      color: Colors.grey,
                      fit: BoxFit.contain,
                    )
                    : Image.memory(
                      _imageData!,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            "assets/icon/logo.png",
                            color: Colors.grey,
                            fit: BoxFit.contain,
                          ),
                    ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: InkWell(
              onTap: _pickImage,
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.upload, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
