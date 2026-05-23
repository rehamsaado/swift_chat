import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// AppBarTheme class provides unified AppBar styling for Smart School applications
/// This ensures consistent AppBar appearance across all features and apps
class SwiftChatAppBarTheme {
  // Private constructor to prevent instantiation
  SwiftChatAppBarTheme._();

  // ==================== LIGHT THEME APP BAR ====================
  static AppBarTheme get lightAppBarTheme => AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.primary.withValues(alpha: 0.2),

    // Title styling with Arabic font support
    titleTextStyle: const TextStyle(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      fontFamily: 'Cairo', // Arabic font support
    ),

    // Icon styling
    iconTheme: const IconThemeData(
      color: AppColors.white,
      size: 24,
    ),

    actionsIconTheme: const IconThemeData(
      color: AppColors.white,
      size: 24,
    ),

    // Center title
    centerTitle: true,

    // Toolbar height
    toolbarHeight: 100,

    // Shape with rounded bottom corners
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),

    // System overlay style
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // ==================== DARK THEME APP BAR ====================
  static AppBarTheme get darkAppBarTheme => AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.darkGradientStart,
    foregroundColor: AppColors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.darkGradientStart.withValues(alpha: 0.3),

    // Title styling with Arabic font support
    titleTextStyle: const TextStyle(
      color: AppColors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      fontFamily: 'Cairo', // Arabic font support
    ),

    // Icon styling
    iconTheme: const IconThemeData(
      color: AppColors.white,
      size: 24,
    ),

    actionsIconTheme: const IconThemeData(
      color: AppColors.white,
      size: 24,
    ),

    // Center title
    centerTitle: true,

    // Toolbar height
    toolbarHeight: 100,

    // Shape with rounded bottom corners
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30),
      ),
    ),

    // System overlay style
    systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // ==================== GRADIENT APP BAR STYLES ====================

  /// Creates a gradient decoration for AppBar
  static Decoration getGradientDecoration({
    required bool isDark,
    GradientType type = GradientType.primary,
  }) {
    List<Color> colors;

    switch (type) {
      case GradientType.primary:
        colors = isDark
            ? [AppColors.darkGradientStart, AppColors.darkGradientEnd]
            : [AppColors.primary, AppColors.secondary];
        break;
      case GradientType.secondary:
        colors = isDark
            ? [AppColors.darkAccentBlue, AppColors.darkAccentPurple]
            : [AppColors.secondary, AppColors.accent];
        break;
      case GradientType.success:
        colors = isDark
            ? [AppColors.darkSuccess, AppColors.darkSuccess.withValues(alpha: 0.8)]
            : [AppColors.success, AppColors.success.withValues(alpha: 0.8)];
        break;
      case GradientType.warning:
        colors = isDark
            ? [AppColors.darkWarning, AppColors.darkWarning.withValues(alpha: 0.8)]
            : [AppColors.warning, AppColors.warning.withValues(alpha: 0.8)];
        break;
      case GradientType.error:
        colors = isDark
            ? [AppColors.darkDestructive, AppColors.darkDestructive.withValues(alpha: 0.8)]
            : [AppColors.error, AppColors.error.withValues(alpha: 0.8)];
        break;
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
      ),
    );
  }

  // ==================== ACTION BUTTON STYLES ====================

  /// Creates a styled action button for AppBar
  static Widget createActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    String? tooltip,
    double? iconSize,
  }) {
    return Container(
      margin: const EdgeInsetsDirectional.only(end: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: iconSize ?? 20,
            ),
          ),
        ),
      ),
    );
  }

  /// Creates a styled badge for AppBar (like notification count)
  static Widget createBadge({
    required String text,
    required bool isDark,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          fontFamily: 'Cairo', // Arabic font support
        ),
      ),
    );
  }

  /// Creates a leading icon with custom styling
  static Widget createLeadingIcon({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
    double? iconSize,
  }) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: iconSize ?? 20,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

/// Enum for different gradient types
enum GradientType {
  primary,
  secondary,
  success,
  warning,
  error,
}
