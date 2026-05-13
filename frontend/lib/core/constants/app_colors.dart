import 'package:flutter/material.dart';

class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFFE87722);
  static const Color primaryDark  = Color(0xFFBF5C0F);
  static const Color primaryLight = Color(0xFFFFAB60);
  static const Color primaryMuted = Color(0x1FE87722);

  // ── Dark theme backgrounds ────────────────────────────────────────
  static const Color bgBase     = Color(0xFF0A0A0A);
  static const Color bgSurface  = Color(0xFF141414);
  static const Color bgCard     = Color(0xFF1C1C1C);
  static const Color bgInput    = Color(0xFF1C1C1C);
  static const Color bgDivider  = Color(0xFF2A2A2A);

  // ── Dark theme text ───────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF2F2F2);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color textMuted     = Color(0xFF555555);
  static const Color textInverse   = Color(0xFF0A0A0A);

  // ── Light theme backgrounds ───────────────────────────────────────
  static const Color lightBgBase    = Color(0xFFF2F3F5);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgCard    = Color(0xFFFFFFFF);
  static const Color lightBgInput   = Color(0xFFF7F8FA);
  static const Color lightBorder    = Color(0xFFE2E5EA);

  // ── Light theme text (high contrast) ─────────────────────────────
  static const Color lightTextPrimary   = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF4B5563);
  static const Color lightTextMuted     = Color(0xFF9CA3AF);

  // ── Semantic (shared) ─────────────────────────────────────────────
  static const Color success      = Color(0xFF22C55E);
  static const Color successMuted = Color(0x1F22C55E);
  static const Color warning      = Color(0xFFEAB308);
  static const Color warningMuted = Color(0x1FEAB308);
  static const Color error        = Color(0xFFEF4444);
  static const Color errorMuted   = Color(0x1FEF4444);
  static const Color info         = Color(0xFF3B82F6);
  static const Color infoMuted    = Color(0x1F3B82F6);

  // ── Status ────────────────────────────────────────────────────────
  static const Color statusPending   = Color(0xFFEAB308);
  static const Color statusProcessed = Color(0xFF3B82F6);
  static const Color statusCompleted = Color(0xFF22C55E);
  static const Color statusRejected  = Color(0xFFEF4444);

  // ── Sync ─────────────────────────────────────────────────────────
  static const Color syncPending = Color(0xFFEAB308);
  static const Color syncSynced  = Color(0xFF22C55E);
  static const Color syncFailed  = Color(0xFFEF4444);
  static const Color syncSyncing = Color(0xFF3B82F6);

  // ── Border (dark default) ─────────────────────────────────────────
  static const Color border      = Color(0xFF2A2A2A);
  static const Color borderFocus = Color(0xFFE87722);
}
