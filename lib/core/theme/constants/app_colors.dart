import 'package:flutter/material.dart';
class AppColors {
  // Private constructor to prevent instantiation
  // مشيد خاص لمنع إنشاء نسخة من الكلاس
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  // ==================== الألوان الأساسية ====================

  /// Primary brand color
  static const Color primary = Color(0xFF4F46E5);

  /// Secondary brand color  Vibrant purple
  /// اللون الثانوي بنفسجي حيوي
  static const Color secondary = Color(0xFF7C3AED);

  /// Accent color for highlights and special elements - Emerald green
  /// لون التأكيد للتمييز والعناصر الخاصة - أخضر زمردي
  static const Color accent = Color(0xFF059669);

  // ==================== MODERN GRADIENT COLORS ====================
  // ==================== ألوان التدرجات العصرية ====================

  /// Primary gradient start - Deep indigo
  /// بداية التدرج الأساسي - نيلة عميقة
  static const Color primaryGradientStart = Color(0xFF4F46E5);

  /// Primary gradient end - Vibrant purple
  /// نهاية التدرج الأساسي - بنفسجي حيوي
  static const Color primaryGradientEnd = Color(0xFF7C3AED);

  /// Secondary gradient start - Emerald
  /// بداية التدرج الثانوي - زمردي
  static const Color secondaryGradientStart = Color(0xFF059669);

  /// Secondary gradient end - Teal
  /// نهاية التدرج الثانوي - تركواز (تيال)
  static const Color secondaryGradientEnd = Color(0xFF7C3AED);

  /// Warm gradient start - Orange
  /// بداية التدرج الدافئ - برتقالي
  static const Color warmGradientStart = Color(0xFFF59E0B);

  /// Warm gradient end - Red
  /// نهاية التدرج الدافئ - أحمر
  static const Color warmGradientEnd = Color(0xFFEF4444);

  /// Cool gradient start - Blue
  /// بداية التدرج البارد - أزرق
  static const Color coolGradientStart = Color(0xFF7C3AED);

  /// Cool gradient end - Indigo
  /// نهاية التدرج البارد - نيلة
  static const Color coolGradientEnd = Color(0xFF6366F1);

  // ==================== SEMANTIC COLORS ====================
  // ==================== الألوان الدلالية (للحالات) ====================

  /// Success color for positive actions and states
  /// لون النجاح للعمليات والحالات الإيجابية
  static const Color success = Color(0xFF10B981);

  /// Warning color for caution states
  /// لون التحذير لحالات التنبيه
  static const Color warning = Color(0xFFF59E0B);

  /// Error color for destructive actions and errors
  /// لون الخطأ للعمليات الهدامة والأخطاء
  static const Color error = Color(0xFFEF4444);

  /// Info color for informational content
  /// لون المعلومات للمحتوى الإرشادي
  static const Color info = Color(0xFF7C3AED);

  // ==================== NEUTRAL COLORS ====================
  // ==================== الألوان المحايدة ====================

  /// Pure white
  /// أبيض نقي
  static const Color white = Color(0xFFFFFFFF);

  /// Pure black
  /// أسود نقي
  static const Color black = Color(0xFF000000);

  /// Transparent color
  /// لون شفاف
  static const Color transparent = Color(0x00000000);

  // ==================== GRAY SCALE ====================
  // ==================== تدرجات الرمادي ====================

  /// Lightest gray
  static const Color gray50 = Color(0xFFF9FAFB);

  /// Very light gray
  static const Color gray100 = Color(0xFFF3F4F6);

  /// Light gray
  static const Color gray200 = Color(0xFFE5E7EB);

  /// Medium light gray
  static const Color gray300 = Color(0xFFD1D5DB);

  /// Medium gray
  static const Color gray400 = Color(0xFF9CA3AF);

  /// Medium dark gray
  static const Color gray500 = Color(0xFF6B7280);

  /// Dark gray
  static const Color gray600 = Color(0xFF4B5563);

  /// Very dark gray
  static const Color gray700 = Color(0xFF374151);

  /// Darkest gray
  static const Color gray800 = Color(0xFF1F2937);

  /// Almost black gray
  static const Color gray900 = Color(0xFF111827);


  // ==================== LIGHT THEME COLORS ====================
  // ==================== ألوان الثيم الفاتح ====================

  /// Light theme background color
  /// لون الخلفية في الثيم الفاتح
  static const Color lightBackground = Color(0xFFF7F7F7);

  /// Light theme surface color
  /// لون الأسطح (الكروت) في الثيم الفاتح
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Light theme primary text color
  /// لون النص الأساسي في الثيم الفاتح
  static const Color lightPrimaryText = Color(0xFF000000);

  /// Light theme secondary text color
  /// لون النص الثانوي في الثيم الفاتح
  static const Color lightSecondaryText = Color(0xFF8A8A8E);

  /// Light theme icon color
  /// لون الأيقونات في الثيم الفاتح
  static const Color lightIcon = Color(0xFF3C3C43);

  /// Light theme divider color
  /// لون الفواصل في الثيم الفاتح
  static const Color lightDivider = Color(0xFFE5E5EA);

  /// Light theme destructive color
  /// اللون التحذيري/الحذف في الثيم الفاتح
  static const Color lightDestructive = Color(0xFFFF3B30);

  /// Light theme accent green - Modern emerald
  /// الأخضر المميز في الثيم الفاتح - زمردي عصري
  static const Color accentGreen = Color(0xFF10B981);

  /// Light theme destructive - Vibrant red
  /// لون الحذف في الثيم الفاتح - أحمر حيوي
  static const Color destructive = Color(0xFFEF4444);

  // ==================== DARK THEME COLORS ====================
  // ==================== ألوان الثيم الداكن ====================

  /// Dark theme background color - Deep modern dark
  /// لون الخلفية في الثيم الداكن - داكن عميق وعصري
  static const Color darkBackground = Color(0xFF0F0F23);

  /// Dark theme surface color - Rich dark surface with blue tint
  /// لون الأسطح في الثيم الداكن - سطح داكن مع مسحة زرقاء
  static const Color darkSurface = Color(0xFF1A1B3A);

  /// Dark theme primary text color - Pure white for maximum contrast
  /// لون النص الأساسي في الداكن - أبيض نقي لأعلى تباين
  static const Color darkPrimaryText = Color(0xFFFFFFFF);

  /// Dark theme secondary text color - Soft purple-gray
  /// لون النص الثانوي في الداكن - رمادي أرجواني ناعم
  static const Color darkSecondaryText = Color(0xFFA1A1AA);

  /// Dark theme icon color - Light purple-white
  /// لون الأيقونات في الداكن - أبيض أرجواني فاتح
  static const Color darkIcon = Color(0xFFF4F4F5);

  /// Dark theme divider color - Subtle purple-gray divider
  /// لون الفواصل في الداكن - فاصل رمادي أرجواني رقيق
  static const Color darkDivider = Color(0xFF3F3F46);

  /// Dark theme destructive color - Vibrant red
  /// لون الحذف في الثيم الداكن - أحمر حيوي
  static const Color darkDestructive = Color(0xFFEF4444);

  // ==================== DARK THEME ACCENT COLORS ====================
  // ==================== ألوان التمييز في الثيم الداكن ====================

  /// Dark theme card background - Modern glassmorphism surface
  /// خلفية الكروت في الداكن - سطح زجاجي عصري
  static const Color darkCardBackground = Color(0xFF1E1E2E);

  /// Dark theme elevated surface - For floating elements with glassmorphism
  /// الأسطح المرتفعة في الداكن - للعناصر العائمة مع تأثير زجاجي
  static const Color darkElevatedSurface = Color(0xFF2A2A3A);

  /// Dark theme gradient start - Modern deep purple
  /// بداية التدرج في الداكن - بنفسجي عميق عصري
  static const Color darkGradientStart = Color(0xFF6366F1);

  /// Dark theme gradient end - Deep purple-blue
  /// نهاية التدرج في الداكن - أزرق بنفسجي عميق
  static const Color darkGradientEnd = Color(0xFF3B82F6);

  /// Dark theme accent blue - Bright modern blue
  /// الأزرق المميز في الداكن - أزرق عصري زاهٍ
  static const Color darkAccentBlue = Color(0xFF60A5FA);

  /// Dark theme accent purple - Vibrant purple
  /// البنفسجي المميز في الداكن - بنفسجي حيوي
  static const Color darkAccentPurple = Color(0xFFA855F7);

  /// Dark theme success green - Modern emerald
  /// أخضر النجاح في الداكن - زمردي عصري
  static const Color darkSuccess = Color(0xFF34D399);

  /// Dark theme warning orange - Vibrant amber
  /// برتقالي التحذير في الداكن - كهرماني حيوي
  static const Color darkWarning = Color(0xFFFBBF24);

  /// Dark theme accent green - Modern emerald
  /// أخضر التمييز في الداكن - زمردي عصري
  static const Color darkAccentGreen = Color(0xFF34D399);

  /// Dark theme error - Vibrant red
  /// لون الخطأ في الداكن - أحمر حيوي
  static const Color darkError = Color(0xFFEF4444);

  // ==================== GLASSMORPHISM COLORS ====================
  // ==================== ألوان التصميم الزجاجي (Glassmorphism) ====================

  /// Glassmorphism overlay light
  /// غطاء زجاجي فاتح
  static const Color glassOverlayLight = Color(0x1AFFFFFF);

  /// Glassmorphism overlay dark
  /// غطاء زجاجي داكن
  static const Color glassOverlayDark = Color(0x1A000000);

  /// Glassmorphism border light
  /// حدود زجاجية فاتحة
  static const Color glassBorderLight = Color(0x33FFFFFF);

  /// Glassmorphism border dark
  /// حدود زجاجية داكنة
  static const Color glassBorderDark = Color(0x33000000);

  // ==================== NEUMORPHISM COLORS ====================
  // ==================== ألوان التصميم البارز (Neumorphism) ====================

  /// Neumorphism light shadow
  /// ظل خفيف للتصميم البارز
  static const Color neuLightShadow = Color(0x1A000000);

  /// Neumorphism dark shadow
  /// ظل غامق للتصميم البارز
  static const Color neuDarkShadow = Color(0x40000000);

  /// Neumorphism highlight
  /// إضاءة للتصميم البارز
  static const Color neuHighlight = Color(0x80FFFFFF);

  // ==================== UTILITY METHODS ====================
  // ==================== دالات مساعدة ====================

  /// Get color with opacity
  /// الحصول على اللون مع درجة شفافية محددة
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get primary color with opacity
  static Color primaryWithOpacity(double opacity) {
    return primary.withValues(alpha: opacity);
  }

  /// Get secondary color with opacity
  static Color secondaryWithOpacity(double opacity) {
    return secondary.withValues(alpha: opacity);
  }

  /// Get accent color with opacity
  static Color accentWithOpacity(double opacity) {
    return accent.withValues(alpha: opacity);
  }

  // ==================== THEME COLOR GETTERS ====================
  // ==================== جلب الألوان حسب نوع الثيم ====================

  /// Get background color based on brightness
  /// جلب لون الخلفية بناءً على سطوع الثيم (فاتح/داكن)
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light ? lightBackground : darkBackground;
  }

  /// Get surface color based on brightness
  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSurface : darkSurface;
  }

  /// Get primary text color based on brightness
  static Color getPrimaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightPrimaryText : darkPrimaryText;
  }

  /// Get secondary text color based on brightness
  static Color getSecondaryTextColor(Brightness brightness) {
    return brightness == Brightness.light ? lightSecondaryText : darkSecondaryText;
  }

  /// Get icon color based on brightness
  static Color getIconColor(Brightness brightness) {
    return brightness == Brightness.light ? lightIcon : darkIcon;
  }

  /// Get divider color based on brightness
  static Color getDividerColor(Brightness brightness) {
    return brightness == Brightness.light ? lightDivider : darkDivider;
  }

  /// Get destructive color based on brightness
  static Color getDestructiveColor(Brightness brightness) {
    return brightness == Brightness.light ? lightDestructive : darkDestructive;
  }
}