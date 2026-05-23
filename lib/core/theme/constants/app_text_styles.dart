import 'package:flutter/material.dart';
import 'app_colors.dart';
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // ==================== FONT FAMILIES ====================
  /// Primary font family for the app - Arabic support
  static const String primaryFont = 'Cairo';

  /// Secondary font family for special cases
  static const String secondaryFont = 'Poppins';

  // ==================== FONT WEIGHTS ====================
  /// Light font weight
  static const FontWeight light = FontWeight.w300;

  /// Regular font weight
  static const FontWeight regular = FontWeight.w400;

  /// Medium font weight
  static const FontWeight medium = FontWeight.w500;

  /// Semi-bold font weight
  static const FontWeight semiBold = FontWeight.w600;

  /// Bold font weight
  static const FontWeight bold = FontWeight.w700;

  /// Extra bold font weight
  static const FontWeight extraBold = FontWeight.w800;

  // ==================== FONT SIZES ====================
  /// Extra small font size (7px)
  static const double xs = 7.0;

  /// Small font size (9px)
  static const double sm = 9.0;

  /// Base font size (11px)
  static const double base = 11.0;

  /// Large font size (13px)
  static const double lg = 13.0;

  /// Extra large font size (15px)
  static const double xl = 15.0;

  /// 2X large font size (17px)
  static const double xl2 = 17.0;

  /// 3X large font size (19px)
  static const double xl3 = 19.0;

  /// 4X large font size (23px)
  static const double xl4 = 23.0;

  /// 5X large font size (27px)
  static const double xl5 = 27.0;

  // ==================== HEADING STYLES ====================

  /// Large heading style (H1)
  static TextStyle get h1 => const TextStyle(
    fontSize: xl4,
    fontWeight: bold,
    fontFamily: primaryFont,
    height: 1.2,
  );

  /// Medium heading style (H2)
  static TextStyle get h2 => const TextStyle(
    fontSize: xl3,
    fontWeight: bold,
    fontFamily: primaryFont,
    height: 1.3,
  );

  /// Small heading style (H3)
  static TextStyle get h3 => const TextStyle(
    fontSize: xl2,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.4,
  );

  /// Extra small heading style (H4)
  static TextStyle get h4 => const TextStyle(
    fontSize: xl,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.4,
  );

  /// Tiny heading style (H5)
  static TextStyle get h5 => const TextStyle(
    fontSize: lg,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.5,
  );

  // ==================== BODY TEXT STYLES ====================

  /// Large body text style
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: xl,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.5,
  );

  /// Medium body text style
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: lg,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.5,
  );

  /// Small body text style
  static TextStyle get bodySmall => const TextStyle(
    fontSize: base,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.5,
  );

  // ==================== LABEL STYLES ====================

  /// Large label style
  static TextStyle get labelLarge => const TextStyle(
    fontSize: lg,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.4,
  );

  /// Medium label style
  static TextStyle get labelMedium => const TextStyle(
    fontSize: base,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.4,
  );

  /// Small label style
  static TextStyle get labelSmall => const TextStyle(
    fontSize: sm,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.4,
  );

  // ==================== BUTTON STYLES ====================

  /// Primary button text style
  static TextStyle get buttonPrimary => const TextStyle(
    fontSize: lg,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.4,
  );

  /// Secondary button text style
  static TextStyle get buttonSecondary => const TextStyle(
    fontSize: base,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.4,
  );

  // ==================== CAPTION STYLES ====================

  /// Caption style for small text
  static TextStyle get caption => const TextStyle(
    fontSize: sm,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.4,
  );

  // ==================== THEME-BASED STYLES ====================

  /// Get heading style with theme colors
  static TextStyle getHeadingStyle(Brightness brightness, {double? fontSize}) {
    return (fontSize != null ? h1.copyWith(fontSize: fontSize) : h1).copyWith(
      color: AppColors.getPrimaryTextColor(brightness),
    );
  }

  /// Get body text style with theme colors
  static TextStyle getBodyStyle(Brightness brightness, {double? fontSize}) {
    return (fontSize != null ? bodyMedium.copyWith(fontSize: fontSize) : bodyMedium).copyWith(
      color: AppColors.getPrimaryTextColor(brightness),
    );
  }

  /// Get secondary text style with theme colors
  static TextStyle getSecondaryTextStyle(Brightness brightness, {double? fontSize}) {
    return (fontSize != null ? bodyMedium.copyWith(fontSize: fontSize) : bodyMedium).copyWith(
      color: AppColors.getSecondaryTextColor(brightness),
    );
  }

  /// Get label style with theme colors
  static TextStyle getLabelStyle(Brightness brightness, {double? fontSize}) {
    return (fontSize != null ? labelMedium.copyWith(fontSize: fontSize) : labelMedium).copyWith(
      color: AppColors.getPrimaryTextColor(brightness),
    );
  }

  // ==================== SEMANTIC STYLES ====================

  /// Success text style
  static TextStyle get success => bodyMedium.copyWith(
    color: AppColors.success,
    fontWeight: medium,
  );

  /// Warning text style
  static TextStyle get warning => bodyMedium.copyWith(
    color: AppColors.warning,
    fontWeight: medium,
  );

  /// Error text style
  static TextStyle get error => bodyMedium.copyWith(
    color: AppColors.error,
    fontWeight: medium,
  );

  /// Info text style
  static TextStyle get info => bodyMedium.copyWith(
    color: AppColors.info,
    fontWeight: medium,
  );

  // ==================== UTILITY METHODS ====================

  /// Create a text style with custom properties
  static TextStyle create({
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? base,
      fontWeight: fontWeight ?? regular,
      fontFamily: fontFamily ?? primaryFont,
      color: color,
      height: height ?? 1.5,
      decoration: decoration,
    );
  }

  /// Create a text style with theme colors
  static TextStyle createWithTheme(
      Brightness brightness, {
        double? fontSize,
        FontWeight? fontWeight,
        String? fontFamily,
        double? height,
        TextDecoration? decoration,
        bool isSecondary = false,
      }) {
    return create(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      color: isSecondary
          ? AppColors.getSecondaryTextColor(brightness)
          : AppColors.getPrimaryTextColor(brightness),
      height: height,
      decoration: decoration,
    );
  }
}