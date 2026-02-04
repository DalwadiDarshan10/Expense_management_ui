import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF665AF0); // #665AF0 RGB(102, 90, 240)
  static const Color primarySup = Color(0xFFFEBC11);
  static const Color transparent = Colors.transparent;
  // #FEBC11 RGB(254, 188, 17)

  // Surface Colors
  static const Color onSurface = Color(0xFF232440); // #232440 RGB(35, 36, 64)
  static const Color surface = Color(0xFFF8F8F8); // #F8F8F8 RGB(248, 248, 248)
  static const Color surfacePrimary = Color(
    0xFF665AF0,
  ); // #665AF0 RGB(102, 90, 240)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  // Secondary & Interactive
  static const Color secondary = Color(
    0xFF6E6E82,
  ); // #6E6E82 RGB(110, 110, 130)
  static const Color interactive = Color(
    0xFF2D82E1,
  ); // #2D82E1 RGB(45, 130, 225)

  // Status Colors
  static const Color critical = Color(0xFFEB5A5A); // #EB5A5A RGB(235, 90, 90)
  static const Color warning = Color(0xFFFABE3C); // #FABE3C RGB(250, 190, 60)
  static const Color success = Color(0xFF3DAB25); // #3DAB25 RGB(61, 171, 37)

  // Border Colors
  static const Color borderCritical = Color(
    0xFFFF5151,
  ); // #FF5151 RGB(255, 81, 81)
  static const Color borderNor = Color(
    0xFFE5E5E5,
  ); // #E5E5E5 RGB(229, 229, 229)

  // Background Colors
  // static const Color white = Color(0xFFFFFFFF); // #FFFFFF RGB(255, 255, 255)
  static const Color background = Color(
    0xFFEEF0F6,
  ); // #EEF0F6 RGB(238, 240, 246)
  static const Color bgSeparator = Color(
    0xFFDDDDDD,
  ); // #DDDDD RGB(102, 90, 240)
  static const Color inputBackground = Color(
    0xFFF0F1F5,
  ); // Light grey for inputs
  static const Color backLanding = Color(0xFFF8F8FC);
  static const Color dividerColor = Color(0xFFE8E7E7);

  // Text Colors (derived from design)
  static const Color primaryText = Color(0xFF232440); // Same as onSurface
  static const Color secondaryText = Color(0xFF6E6E82); // Same as secondary
  static const Color hintText = Color(0xFFA0A0A0);

  // Alias for error (same as critical)
  static const Color error = Color(0xFFEB5A5A);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);

  // Shadow Colors
  static const Color dropShadow = Color(0x1A000000);
  static const Color dropSection = Color(0x0D000000);
  static const Color dropButton = Color(0x1A665AF0);
}
