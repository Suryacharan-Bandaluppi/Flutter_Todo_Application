import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF1FE592);
  static const Color darkGreen = Color(0xFF0F2E23);
  static const Color mediumGreen = Color(0xFF163D31);
  static const Color darkBlue = Color(0xFF0B1220);

  // Text Colors
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textWhite60 = Colors.white60;
  static const Color textWhite54 = Colors.white54;
  static const Color textWhite38 = Colors.white38;
  static const Color textWhite24 = Colors.white24;
  static const Color textWhite12 = Colors.white12;
  static const Color textBlack = Colors.black;

  // Accent Colors
  static const Color accentRed = Colors.redAccent;
  static const Color errorRed = Colors.redAccent;

  // Border Radius
  static const double borderRadiusSmall = 10.0;
  static const double borderRadiusMedium = 15.0;
  static const double borderRadiusLarge = 20.0;
  static const double borderRadiusXLarge = 30.0;

  // Spacing
  static const EdgeInsets paddingSmall = EdgeInsets.all(10.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(20.0);

  // Input Field Decoration
  static InputDecoration inputDecoration({
    required String hintText,
    Color fillColor = mediumGreen,
    Color hintColor = textWhite38,
    double borderRadius = borderRadiusMedium,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: hintColor),
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Tag Chip Decoration
  static BoxDecoration tagDecoration({
    required bool isSelected,
    double borderRadius = borderRadiusLarge,
  }) {
    return BoxDecoration(
      color: isSelected ? primaryGreen : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: textWhite24),
    );
  }

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22,
    color: textWhite,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    color: textWhite,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyStyle = TextStyle(fontSize: 14, color: textWhite);

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12,
    color: textWhite38,
  );

  static const TextStyle tagStyle = TextStyle(
    fontSize: 11,
    color: textBlack,
    fontWeight: FontWeight.w500,
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle({
    Color backgroundColor = primaryGreen,
    Color textColor = textBlack,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: textColor,
    );
  }

  // Date Picker Theme
  static ThemeData datePickerTheme() {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        onPrimary: textBlack,
        surface: darkGreen,
        onSurface: textWhite,
      ),
    );
  }

  // App Theme Data
  static ThemeData get appTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: darkBlue,
      primaryColor: primaryGreen,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryGreen,
        surface: darkGreen,
        error: errorRed,
        onPrimary: textBlack,
        onSecondary: textBlack,
        onSurface: textWhite,
        onError: textWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBlue,
        elevation: 0,
        iconTheme: IconThemeData(color: textWhite),
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: textBlack,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: mediumGreen,
        hintStyle: const TextStyle(color: textWhite38),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textWhite,
        ),
        bodyLarge: TextStyle(fontSize: 14, color: textWhite60),
        bodyMedium: TextStyle(fontSize: 12, color: textWhite38),
      ),
    );
  }
}
