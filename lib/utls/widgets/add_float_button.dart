import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';

class AddFloatButton extends StatelessWidget {
 final String label;
 final void Function()? onPressed;
  const AddFloatButton({super.key,required this.label,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      onPressed: onPressed,
      label:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(label), Icon(Icons.add)],
      ),
    );
  }
}
