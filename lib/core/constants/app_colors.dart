import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Health-Tech Palette
  static const Color primary = Color(0xFF00897B); // Medical Teal
  static const Color primaryDark = Color(0xFF00695C);
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color secondary = Color(0xFF0284C7); // Clinical Cyan
  static const Color secondaryLight = Color(0xFFE0F2FE);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Clean Slate-tinted White
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Text & Typography
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF94A3B8); // Slate 400

  // Status Badges
  // 1. Solicitada (Pendiente) -> Warm Amber
  static const Color statusSolicitadaBg = Color(0xFFFEF3C7);
  static const Color statusSolicitadaText = Color(0xFFB45309);

  // 2. Confirmada -> Medical Emerald
  static const Color statusConfirmadaBg = Color(0xFFD1FAE5);
  static const Color statusConfirmadaText = Color(0xFF065F46);

  // 3. Cancelada -> Soft Red / Rose
  static const Color statusCanceladaBg = Color(0xFFFEE2E2);
  static const Color statusCanceladaText = Color(0xFF991B1B);

  // 4. Atendida -> Slate Blue / Neutral
  static const Color statusAtendidaBg = Color(0xFFE2E8F0);
  static const Color statusAtendidaText = Color(0xFF334155);

  // Accents & Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);
  static const Color star = Color(0xFFF59E0B);
}
