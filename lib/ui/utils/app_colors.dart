import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF4A56E2);
  static const Color primaryLight = Color(0xFF6C75F0);
  static const Color primaryDark = Color(0xFF3340C9);

  // Accent
  static const Color accent = Color(0xFF00BFA6);
  static const Color accentLight = Color(0xFF5DF2D6);

  // Background
  static const Color scaffoldBg = Color(0xFFF5F7FA);
  static const Color cardBg = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textHint = Color(0xFFB2BEC3);

  // Status colors
  static const Color statusNew = Color(0xFF0984E3);
  static const Color statusProgress = Color(0xFFFDAB3D);
  static const Color statusCancelled = Color(0xFFE17055);
  static const Color statusCompleted = Color(0xFF00B894);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4A56E2), Color(0xFF6C75F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00BFA6), Color(0xFF5DF2D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFE17055), Color(0xFFFDAB3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [Color(0xFF0984E3), Color(0xFF74B9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: primary.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
