import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foot_track/utls/app_theam.dart';
import 'package:foot_track/utls/font_style.dart';

class PlayerSelectCard extends StatelessWidget {
  final String name;
  final Function(bool?)? onChanged;
  final bool isSelected;
  final bool enabled;
  final Widget subTitele;
  final Uint8List? imageData;
  const PlayerSelectCard({
    super.key,
    required this.name,
    this.onChanged,
    required this.isSelected,
    required this.enabled,
    required this.subTitele,
    this.imageData,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Theme.of(context).colorScheme.secondary),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: CheckboxListTile(
          secondary: CircleAvatar(
            backgroundImage:
               imageData != null
                    ? MemoryImage(imageData!)
                    : null,
            child:imageData == null ? const Icon(Icons.person) : null,
          ),
          title: Text(
            name,
            style: Fontstyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          value: isSelected,
          onChanged: onChanged,
          enabled: enabled,
          subtitle: subTitele,

          activeColor: AppColors.hilight,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(100),
          ),
          checkColor: AppColors.white,
        ),
      ),
    );
  }
}
