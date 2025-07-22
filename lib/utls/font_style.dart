import 'package:flutter/widgets.dart';

class Fontstyle extends TextStyle {
  Fontstyle({
    FontStyle? fontStyle,
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
    // Add other TextStyle properties as needed
  }) : super(
         fontFamily: 'Poppins', // Set Poppins as the font family
         fontStyle: fontStyle,
         fontWeight: fontWeight,
         fontSize: fontSize,
         color: color,
       );

  @override
  FontStyle? get fontStyle => super.fontStyle;
}
