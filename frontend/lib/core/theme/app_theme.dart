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
      scaffoldBackgroundColor: AppColors.bgBase,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary, fontSize: 18,
          fontWeight: FontWeight.w700, letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: _inputTheme(Brightness.dark),
      elevatedButtonTheme: _elevatedBtnTheme(),
      outlinedButtonTheme: _outlinedBtnTheme(),
      textButtonTheme: _textBtnTheme(),
      chipTheme: _chipTheme(),
      dividerTheme: const DividerThemeData(
        color: AppColors.border, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgCard,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.3)),
      ),
    );
  }

  // ── Light theme ───────────────────────────────────────────────────
  static ThemeData get lightTheme {
    const bg       = Color(0xFFF5F5F5);
    const surface  = Color(0xFFFFFFFF);
    const card     = Color(0xFFFFFFFF);
    const border   = Color(0xFFE0E0E0);
    const txtPrim  = Color(0xFF1A1A1A);
    const txtSec   = Color(0xFF6B6B6B);
    const txtMuted = Color(0xFFAAAAAA);
    const input    = Color(0xFFF8F8F8);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bg,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: txtPrim,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: txtPrim, fontSize: 18,
          fontWeight: FontWeight.w700, letterSpacing: -0.2,
        ),
        iconTheme: IconThemeData(color: txtPrim),
      ),
      cardTheme: CardThemeData(
        color: card, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: input,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error)),
        labelStyle: const TextStyle(color: txtSec, fontSize: 12),
        hintStyle: const TextStyle(color: txtMuted, fontSize: 12),
      ),
      elevatedButtonTheme: _elevatedBtnTheme(),
      outlinedButtonTheme: _outlinedBtnTheme(),
      textButtonTheme: _textBtnTheme(),
      chipTheme: _chipTheme(),
      dividerTheme: const DividerThemeData(
        color: border, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: txtMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.4)
            : Colors.grey.withValues(alpha: 0.3)),
      ),
    );
  }

  // ── Shared component themes ───────────────────────────────────────
  static InputDecorationTheme _inputTheme(Brightness b) {
    return InputDecorationTheme(
      filled: true, fillColor: AppColors.bgInput,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary, width: 1.5)),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error)),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error, width: 1.5)),
      labelStyle: AppTextStyles.caption,
      hintStyle: AppTextStyles.caption.copyWith(
        color: AppColors.textMuted),
      errorStyle: AppTextStyles.caption.copyWith(
        color: AppColors.error),
    );
  }

  static ElevatedButtonThemeData _elevatedBtnTheme() =>
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.border,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.button,
      ),
    );

  static OutlinedButtonThemeData _outlinedBtnTheme() =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.button.copyWith(
          color: AppColors.primary),
      ),
    );

  static TextButtonThemeData _textBtnTheme() =>
    TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary),
      ),
    );

  static ChipThemeData _chipTheme() => ChipThemeData(
    backgroundColor: AppColors.bgCard,
    selectedColor: AppColors.primaryMuted,
    side: const BorderSide(color: AppColors.border),
    labelStyle: AppTextStyles.caption,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );
}
