import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// ThemeManager class handles theme state management and persistence
/// Provides methods to switch between light and dark themes
/// Automatically detects system theme and persists user preferences
class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether the manager has been initialized
  bool get isInitialized => _isInitialized;

  /// Whether the current theme is dark
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Whether the current theme is light
  bool get isLightMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.light;
    }
    return _themeMode == ThemeMode.light;
  }

  /// Initialize the theme manager
  /// Loads saved theme preference from SharedPreferences
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_themeKey);

      if (savedThemeMode != null) {
        _themeMode = _parseThemeMode(savedThemeMode);
      } else {
        _themeMode = ThemeMode.system;
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing theme manager: $e');
      _themeMode = ThemeMode.system;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Set theme mode
  /// Saves the preference to SharedPreferences
  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (_themeMode == themeMode) return;

    _themeMode = themeMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeModeToString(themeMode));
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }

    notifyListeners();
  }

  /// Toggle between light and dark themes
  /// If system theme is selected, switches to light theme
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.system) {
      await setThemeMode(ThemeMode.light);
    } else if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Get current theme data
  ThemeData getCurrentTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        return AppTheme.getSystemTheme();
    }
  }

  /// Get theme data for specific brightness
  ThemeData getThemeForBrightness(Brightness brightness) {
    return AppTheme.getTheme(brightness);
  }

  /// Create app-specific theme with custom accent color
  ThemeData createAppTheme(Color accentColor) {
    final brightness = isDarkMode ? Brightness.dark : Brightness.light;
    return AppTheme.createAppTheme(
      brightness: brightness,
      accentColor: accentColor,
    );
  }
  //
  // /// Get teacher app theme
  // ThemeData getTeacherTheme() {
  //   return createAppTheme(AppColors.teacherAccent);
  // }
  //
  // /// Get student app theme
  // ThemeData getStudentTheme() {
  //   return createAppTheme(AppColors.studentAccent);
  // }
  //
  // /// Get parent app theme
  // ThemeData getParentTheme() {
  //   return createAppTheme(AppColors.parentAccent);
  // }

  // ==================== PRIVATE METHODS ====================

  /// Parse theme mode from string
  ThemeMode _parseThemeMode(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  /// Convert theme mode to string
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}

/// Extension to provide easy access to theme manager
extension ThemeManagerExtension on BuildContext {
  /// Get theme manager from context
  ThemeManager get themeManager {
    return Theme.of(this).extension<ThemeManager>() ?? ThemeManager();
  }

  /// Get current theme data
  ThemeData get currentTheme {
    return Theme.of(this);
  }

  /// Get current brightness
  Brightness get currentBrightness {
    return Theme.of(this).brightness;
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    return Theme.of(this).brightness == Brightness.light;
  }
}