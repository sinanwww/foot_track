import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF037FDD);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  // static const Color hilight = Color(0xFF12D84D);
  static const Color secondary = Color(0xFF586C5C);
  static const Color scaffoldBg = Color(0xFFEDE8E8);
  // static const Color typeFieldBg = Color(0xFFDCD2D2);
  static const Color grey = Color(0xFF5B5B5B);
  static const Color sarfaceColor = Color(0xFF333333);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 219, 215, 215),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),

    textTheme: TextTheme(bodyMedium: TextStyle(color: AppColors.black)),

    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.primary,
      secondary: Colors.black,
      onSecondary: Colors.grey,
      error: Colors.red,
      onError: Colors.red,
      surface: Colors.white,
      onSurface: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.grey,
      onPrimary: AppColors.primary,
      secondary: Colors.white,
      onSecondary: Colors.grey,
      error: Colors.red,
      onError: Colors.red,
      surface: AppColors.sarfaceColor,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: AppColors.black,
    //app bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.sarfaceColor,
      foregroundColor: AppColors.white,
    ),
    //bottr navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      elevation: 5,
    ),

    // card theme
    cardColor: AppColors.sarfaceColor,

    // Text theme
    textTheme: TextTheme(bodyMedium: TextStyle(color: AppColors.white)),
  );
}
