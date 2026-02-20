import 'package:flutter/material.dart';

class AppColors {
  // Main Theme Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF26C6DA);
  static const Color background = Color(0xFF0A0E21);
  static const Color surface = Color(0xFF1D1E33);
  static const Color error = Color(0xFFEF5350);
  static const Color cardBorder = Color(0xFF2A2D3E);
  
  // Dark Theme Colors (Varsayılan)
  static const Color primaryDark = Color(0xFF1E88E5);
  static const Color secondaryDark = Color(0xFF26C6DA);
  static const Color backgroundDark = Color(0xFF0A0E21);
  static const Color surfaceDark = Color(0xFF1D1E33);
  static const Color cardDark = Color(0xFF1D1E33);
  
  // Accent Colors
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentRed = Color(0xFFEF5350);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentPurple = Color(0xFF9C27B0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0BEC5);
  static const Color textHint = Color(0xFF78909C);
  
  // Fuel Station Colors
  static const Color shellColor = Color(0xFFFFD700);
  static const Color opetColor = Color(0xFFFF6B00);
  static const Color bpColor = Color(0xFF00A651);
  static const Color totalColor = Color(0xFFEE1C25);
  static const Color petrolOfisiColor = Color(0xFF0066CC);
  
  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFEF5350),
    Color(0xFFFF9800),
    Color(0xFFAB47BC),
  ];
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
