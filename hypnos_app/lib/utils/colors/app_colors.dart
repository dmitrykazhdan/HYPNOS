import 'package:flutter/material.dart';

class AppColors {
  // Insomnia-friendly color palette
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color secondaryOrange = Color(0xFFFF8A65);
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnSurfaceVariant = Color(0xFFB0B0B0);
  static const Color accentBlue = Color(0xFF64B5F6);
  static const Color accentPurple = Color(0xFF9575CD);

  // Gradient for the pulsating sphere
  static const LinearGradient sphereGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryOrange,
      secondaryOrange,
      Color(0xFFFF7043),
    ],
  );
} 