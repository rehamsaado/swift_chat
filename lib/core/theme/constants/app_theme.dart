import 'package:flutter/material.dart';
import 'package:swift_chat/core/theme/constants/app_bar_theme.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // تم تغييرها إلى static final لأنها تستقبل قيم من ملف خارجي
  static final Color primary = AppColors.primary;
  static final Color secondary = AppColors.secondary;
  static final Color accent = AppColors.accent;

  // ألوان الحالات
  static final Color success = AppColors.success;
  static final Color warning = AppColors.warning;
  static final Color error = AppColors.error;

  // ألوان النصوص والأسطح
  static final Color surfaceLight = AppColors.lightSurface;
  static final Color surfaceDark = AppColors.darkSurface;
  static final Color textPrimary = const Color(0xFF1A1A1A);
  static final Color textSecondary = const Color(0xFF666666);
  static final Color textDark = const Color(0xFFE0E0E0);

  // ==================== LIGHT THEME ====================
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    // حذفنا const هنا لأن الألوان بالداخل متغيرة (final)
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      tertiary: accent,
      surface: surfaceLight,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: SwiftChatAppBarTheme.lightAppBarTheme,
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textSecondary),
      labelLarge: TextStyle(color: textPrimary),
      labelMedium: TextStyle(color: textSecondary),
      labelSmall: TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
    // ... بقية الإعدادات
  );

  // ==================== DARK THEME ====================
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Cairo',
    colorScheme: ColorScheme.dark(
      primary: accent,
      secondary: primary,
      tertiary: secondary,
      surface: surfaceDark,
      error: error,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: textDark,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    // تأكد أن الاسم هنا SwiftChat وليس SmartSchool
    appBarTheme: SwiftChatAppBarTheme.darkAppBarTheme,
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textDark, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: textDark),
      bodyMedium: const TextStyle(color: Colors.grey),
    ),
    // ... بقية الإعدادات
  );

  // ==================== FUNCTIONS ====================

  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  static ThemeData getSystemTheme() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return getTheme(brightness);
  }

  static ThemeData createAppTheme({
    required Brightness brightness,
    required Color accentColor,
  }) {
    final baseTheme = getTheme(brightness);
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: accentColor,
        secondary: accentColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}