import 'package:flutter/material.dart';
import '../../app.dart';

class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────
  static const Color primary      = Color(0xFFE87722);
  static const Color primaryDark  = Color(0xFFBF5C0F);
  static const Color primaryLight = Color(0xFFFFAB60);
  static const Color primaryMuted = Color(0x1FE87722);

  // ── Dark theme backgrounds ────────────────────────────────────────
  static const Color darkBgBase     = Color(0xFF0A0A0A);
  static const Color darkBgSurface  = Color(0xFF141414);
  static const Color darkBgCard     = Color(0xFF1C1C1C);
  static const Color darkBgInput    = Color(0xFF1C1C1C);
  static const Color darkBorder     = Color(0xFF2A2A2A);

  // ── Dark theme text ───────────────────────────────────────────────
  static const Color darkTextPrimary   = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFF9A9A9A);
  static const Color darkTextMuted     = Color(0xFF555555);

  // ── Light theme backgrounds ───────────────────────────────────────
  static const Color lightBgBase    = Color(0xFFF0F2F5);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgCard    = Color(0xFFFFFFFF);
  static const Color lightBgInput   = Color(0xFFF5F6F8);
  static const Color lightBorder    = Color(0xFFE4E7EC);

  // ── Light theme text ──────────────────────────────────────────────
  static const Color lightTextPrimary   = Color(0xFF0F1419);
  static const Color lightTextSecondary = Color(0xFF536471);
  static const Color lightTextMuted     = Color(0xFFAAB4BE);

  // ── Dynamic theme properties ──────────────────────────────────────
  static bool get _isDark => themeNotifier.value == ThemeMode.dark;

  static Color get bgBase => _isDark ? darkBgBase : lightBgBase;
  static Color get bgSurface => _isDark ? darkBgSurface : lightBgSurface;
  static Color get bgCard => _isDark ? darkBgCard : lightBgCard;
  static Color get bgInput => _isDark ? darkBgInput : lightBgInput;
  static Color get border => _isDark ? darkBorder : lightBorder;

  static Color get textPrimary => _isDark ? darkTextPrimary : lightTextPrimary;
  static Color get textSecondary => _isDark ? darkTextSecondary : lightTextSecondary;
  static Color get textMuted => _isDark ? darkTextMuted : lightTextMuted;

  // ── Semantic ──────────────────────────────────────────────────────
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

  // ── Borders ───────────────────────────────────────────────────────
  static const Color borderFocus = Color(0xFFE87722);

  // ── Theme-aware helpers ───────────────────────────────────────────
  static Color cardColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkBgCard : lightBgCard;

  static Color surfaceColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkBgSurface : lightBgSurface;

  static Color scaffoldColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkBgBase : lightBgBase;

  static Color dividerColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkBorder : lightBorder;

  static Color textPrimaryColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkTextPrimary : lightTextPrimary;

  static Color textSecondaryColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkTextSecondary : lightTextSecondary;

  static Color textMutedColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
      ? darkTextMuted : lightTextMuted;
}
