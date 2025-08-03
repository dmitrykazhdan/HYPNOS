import 'package:flutter/material.dart';

class AccessibilityUtils {
  static ThemeData getAccessibilityTheme(ThemeData baseTheme, bool isHighContrast) {
    if (!isHighContrast) return baseTheme;

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: Colors.white,
        secondary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
      textTheme: baseTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
        fillColor: Colors.white,
        filled: true,
        labelStyle: const TextStyle(color: Colors.black),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }

  static TextStyle getAccessibilityTextStyle(TextStyle baseStyle, bool isLargeText) {
    if (!isLargeText) return baseStyle;

    return baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * 1.3,
    );
  }

  static double getAccessibilityButtonSize(bool isLargeText) {
    return isLargeText ? 60.0 : 44.0;
  }

  static EdgeInsets getAccessibilityPadding(bool isLargeText) {
    return isLargeText 
        ? const EdgeInsets.all(16.0)
        : const EdgeInsets.all(12.0);
  }
} 