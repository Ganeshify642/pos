import 'package:flutter/material.dart';

class AppColors {
  // Gopal Vadapav POS EZO Brand Colors
  static const Color primary = Color(0xFFEA580C); // Warm Orange-600
  static const Color primaryLight = Color(0xFFFB923C); // Orange-400
  static const Color primaryDark = Color(0xFFC2410C); // Orange-700

  static const Color secondary = Color(0xFF4F46E5); // Indigo-600
  static const Color secondaryLight = Color(0xFF6366F1); // Indigo-500

  static const Color accent = Color(0xFF059669); // Emerald-600
  static const Color accentLight = Color(0xFF10B981); // Emerald-500

  // Status Colors
  static const Color pending = Color(0xFFD97706);   // Amber-600
  static const Color preparing = Color(0xFF2563EB);  // Blue-600
  static const Color ready = Color(0xFF059669);      // Emerald-600
  static const Color completed = Color(0xFF64748B);  // Slate-500

  // Stock Status
  static const Color inStock = Color(0xFF059669);
  static const Color lowStock = Color(0xFFD97706);
  static const Color outOfStock = Color(0xFFDC2626);

  // Backgrounds (Light Theme Default)
  static const Color lightBg = Color(0xFFF8FAFC);      // Slate-50
  static const Color lightSurface = Color(0xFFFFFFFF); // White
  static const Color lightCard = Color(0xFFFFFFFF);    // Clean White Card
  static const Color lightBorder = Color(0xFFE2E8F0);  // Slate-200

  // Backgrounds (Dark Theme)
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkCard = Color(0xFF334155);
  static const Color darkBorder = Color(0xFF475569);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFF8FAFC);

  // Revenue / Finance
  static const Color revenue = Color(0xFF059669);
  static const Color expense = Color(0xFFDC2626);
  static const Color netEarnings = Color(0xFFEA580C);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient revenueGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFC2410C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
