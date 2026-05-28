import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  // ── Dark theme ────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBgBase,
      primaryColor: AppColors.primary,
      cardColor: AppColors.darkBgCard,
      dividerColor: AppColors.darkBorder,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.darkBgSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
      ),
      textTheme: _buildTextTheme(
        primary: AppColors.darkTextPrimary,
        secondary: AppColors.darkTextSecondary,
        muted: AppColors.darkTextMuted,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBgSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.darkTextPrimary, fontSize: 18,
          fontWeight: FontWeight.w700, letterSpacing: -0.2),
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkBgCard, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.darkBorder, width: 1)),
      ),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.darkBgInput, border: AppColors.darkBorder,
        label: AppColors.darkTextSecondary, hint: AppColors.darkTextMuted),
      elevatedButtonTheme: _elevatedBtn(),
      outlinedButtonTheme: _outlinedBtn(),
      textButtonTheme: _textBtn(),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBgSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextMuted,
        type: BottomNavigationBarType.fixed, elevation: 0),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkBgCard,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : const Color(0xFF6B7280)),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.4) : const Color(0xFF374151))),
      chipTheme: _chipTheme(
        bg: AppColors.darkBgCard, border: AppColors.darkBorder,
        label: AppColors.darkTextSecondary),
    );
  }

  // ── Light theme ───────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBgBase,
      primaryColor: AppColors.primary,
      cardColor: AppColors.lightBgCard,
      dividerColor: AppColors.lightBorder,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.lightBgSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
      ),
      textTheme: _buildTextTheme(
        primary: AppColors.lightTextPrimary,
        secondary: AppColors.lightTextSecondary,
        muted: AppColors.lightTextMuted,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBgSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.lightTextPrimary, fontSize: 18,
          fontWeight: FontWeight.w700, letterSpacing: -0.2),
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightBgCard, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder, width: 1)),
      ),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.lightBgInput, border: AppColors.lightBorder,
        label: AppColors.lightTextSecondary, hint: AppColors.lightTextMuted),
      elevatedButtonTheme: _elevatedBtn(),
      outlinedButtonTheme: _outlinedBtn(),
      textButtonTheme: _textBtn(),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightBgSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed, elevation: 0),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightBgCard,
        contentTextStyle: TextStyle(color: AppColors.lightTextPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder)),
        behavior: SnackBarBehavior.floating),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : const Color(0xFFD1D5DB)),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.35) : const Color(0xFFE5E7EB))),
      chipTheme: _chipTheme(
        bg: AppColors.lightBgCard, border: AppColors.lightBorder,
        label: AppColors.lightTextSecondary),
    );
  }

  // ── Shared text theme ─────────────────────────────────────────────
  static TextTheme _buildTextTheme({
    required Color primary, required Color secondary, required Color muted,
  }) => TextTheme(
    displayLarge:  TextStyle(color: primary, fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(color: primary, fontWeight: FontWeight.w700),
    headlineMedium:TextStyle(color: primary, fontWeight: FontWeight.w600),
    titleLarge:    TextStyle(color: primary, fontWeight: FontWeight.w600),
    titleMedium:   TextStyle(color: primary, fontWeight: FontWeight.w500),
    bodyLarge:     TextStyle(color: primary),
    bodyMedium:    TextStyle(color: primary),
    bodySmall:     TextStyle(color: secondary),
    labelLarge:    TextStyle(color: primary, fontWeight: FontWeight.w600),
    labelMedium:   TextStyle(color: secondary),
    labelSmall:    TextStyle(color: muted),
  );

  // ── Shared component factories ────────────────────────────────────
  static InputDecorationTheme _inputTheme({
    required Color fill, required Color border,
    required Color label, required Color hint,
  }) => InputDecorationTheme(
    filled: true, fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error)),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5)),
    labelStyle: TextStyle(color: label, fontSize: 12),
    hintStyle: TextStyle(color: hint, fontSize: 13),
    errorStyle: const TextStyle(color: AppColors.error, fontSize: 11),
  );

  static ElevatedButtonThemeData _elevatedBtn() =>
    ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFF4B5563),
      disabledForegroundColor: const Color(0xFF9CA3AF),
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: AppTextStyles.button));

  static OutlinedButtonThemeData _outlinedBtn() =>
    OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  static TextButtonThemeData _textBtn() =>
    TextButtonThemeData(style: TextButton.styleFrom(
      foregroundColor: AppColors.primary));

  static ChipThemeData _chipTheme({
    required Color bg, required Color border, required Color label,
  }) => ChipThemeData(
    backgroundColor: bg,
    selectedColor: AppColors.primaryMuted,
    side: BorderSide(color: border),
    labelStyle: TextStyle(color: label, fontSize: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6));
}
