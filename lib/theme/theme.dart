import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData light() => ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
        titleLarge: POSTextTheme.titleL,
        titleMedium: POSTextTheme.titleM,
        titleSmall: POSTextTheme.titleS,
        headlineLarge: POSTextTheme.headLineL,
        headlineMedium: POSTextTheme.headLineM,
        headlineSmall: POSTextTheme.headLineS,
        bodyLarge: POSTextTheme.bodyL,
        bodyMedium: POSTextTheme.bodyM,
        bodySmall: POSTextTheme.bodyS,
        labelLarge: POSTextTheme.labelL,
        labelMedium: POSTextTheme.labelM,
        labelSmall: POSTextTheme.labelS,
      )),
      primaryColor: ThemeColor.primaryColor,
      disabledColor: ThemeColor.infoColor,
      brightness: Brightness.light,
      hintColor: ThemeColor.infoColor,
      textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(foregroundColor: ThemeColor.primaryColor)),
      colorScheme: const ColorScheme.light(
              brightness: Brightness.light,
              primary: ThemeColor.primaryColor,
              secondary: ThemeColor.secondaryColor,
              surface: ThemeColor.surfaceColor,
              onBackground: ThemeColor.onBackgroundColor,
              background: ThemeColor.backgroundColor)
          .copyWith(error: ThemeColor.errorColor),
    );

ThemeData dark() => ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
        titleLarge: POSTextTheme.titleL,
        titleMedium: POSTextTheme.titleM,
        titleSmall: POSTextTheme.titleS,
        headlineLarge: POSTextTheme.headLineL,
        headlineMedium: POSTextTheme.headLineM,
        headlineSmall: POSTextTheme.headLineS,
        bodyLarge: POSTextTheme.bodyL,
        bodyMedium: POSTextTheme.bodyM,
        bodySmall: POSTextTheme.bodyS,
        labelLarge: POSTextTheme.labelL,
        labelMedium: POSTextTheme.labelM,
        labelSmall: POSTextTheme.labelS,
      )),
      primaryColor: ThemeColor.primaryColor,
      disabledColor: ThemeColor.infoColor,
      brightness: Brightness.dark,
      hintColor: ThemeColor.infoColor,
      cardColor: Colors.white,
      textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(foregroundColor: ThemeColor.primaryColor)),
      colorScheme: const ColorScheme.dark(
              brightness: Brightness.dark,
              primary: ThemeColor.primaryColor,
              secondary: ThemeColor.secondaryColor,
              onBackground: ThemeColor.onBackgroundColorDark,
              background: ThemeColor.backgroundColorDark)
          .copyWith(
        error: ThemeColor.errorColor,
      ),
    );

class ThemeColor {
  static const primaryColor = Color(0xff2B46F2);
  static const secondaryColor = Color(0xffFDD835);
  static const surfaceColor = Color(0xffe9ebed);
  static const backgroundColor = Color(0xffffffff);
  static const backgroundColorDark = Color(0xff121212);
  static const onBackgroundColor = Color(0xff121212);
  static const onBackgroundColorDark = Color(0xffffffff);
  static const errorColor = Color(0xFFF44336);
  static const infoColor = Color(0xFFB8B8B8);
}

class POSTextTheme {
  static const titleL = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 34 / 28,
  );
  static const titleM = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Color(0xff000000),
    height: 30 / 24,
  );
  static const titleS = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 28 / 22,
  );
  static const headLineL = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 26 / 20,
  );
  static const headLineM = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 25 / 18,
  );
  static const headLineS = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 25 / 18,
  );
  static const bodyL = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );
  static const bodyM = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
  );
  static const bodyS = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );
  static const labelL = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xff000000),
    height: 24 / 16,
  );
  static const labelM = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xff000000),
    height: 22 / 14,
  );
  static const labelS = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
  );
}
