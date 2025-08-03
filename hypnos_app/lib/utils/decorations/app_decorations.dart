import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class AppDecorations {
  // Glass morphism effect
  static BoxDecoration glassMorphismDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        spreadRadius: 0,
      ),
    ],
  );

  // Message bubble styles
  static BoxDecoration userMessageDecoration = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryOrange.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration aiMessageDecoration = BoxDecoration(
    color: AppColors.darkSurfaceVariant,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Colors.white.withValues(alpha: 0.1),
      width: 1,
    ),
  );
} 