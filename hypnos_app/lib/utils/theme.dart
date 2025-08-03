// Main theme facade - imports and re-exports all theme components
import 'package:flutter/material.dart';

export 'colors/app_colors.dart';
export 'decorations/app_decorations.dart';
export 'accessibility/accessibility_utils.dart';
export 'theme_data/app_theme_data.dart';

import 'colors/app_colors.dart';
import 'decorations/app_decorations.dart';
import 'accessibility/accessibility_utils.dart';
import 'theme_data/app_theme_data.dart';

/// Main theme class that provides a unified interface to all theme components
class AppTheme {
  // Re-export colors for convenience
  static const Color primaryOrange = AppColors.primaryOrange;
  static const Color secondaryOrange = AppColors.secondaryOrange;
  static const Color darkBackground = AppColors.darkBackground;
  static const Color darkSurface = AppColors.darkSurface;
  static const Color darkSurfaceVariant = AppColors.darkSurfaceVariant;
  static const Color darkOnSurface = AppColors.darkOnSurface;
  static const Color darkOnSurfaceVariant = AppColors.darkOnSurfaceVariant;
  static const Color accentBlue = AppColors.accentBlue;
  static const Color accentPurple = AppColors.accentPurple;

  // Re-export gradients
  static const LinearGradient sphereGradient = AppColors.sphereGradient;

  // Re-export decorations
  static BoxDecoration get glassMorphismDecoration => AppDecorations.glassMorphismDecoration;
  static BoxDecoration get userMessageDecoration => AppDecorations.userMessageDecoration;
  static BoxDecoration get aiMessageDecoration => AppDecorations.aiMessageDecoration;

  // Re-export theme data
  static ThemeData get lightTheme => AppThemeData.lightTheme;
  static ThemeData get darkTheme => AppThemeData.darkTheme;

  // Re-export accessibility utilities
  static ThemeData getAccessibilityTheme(ThemeData baseTheme, bool isHighContrast) {
    return AccessibilityUtils.getAccessibilityTheme(baseTheme, isHighContrast);
  }

  static TextStyle getAccessibilityTextStyle(TextStyle baseStyle, bool isLargeText) {
    return AccessibilityUtils.getAccessibilityTextStyle(baseStyle, isLargeText);
  }

  static double getAccessibilityButtonSize(bool isLargeText) {
    return AccessibilityUtils.getAccessibilityButtonSize(isLargeText);
  }

  static EdgeInsets getAccessibilityPadding(bool isLargeText) {
    return AccessibilityUtils.getAccessibilityPadding(isLargeText);
  }
} 