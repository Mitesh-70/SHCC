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
      cardColor: AppColors.bgCard,
      dividerColor: AppColors.border,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.bgSurface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: _darkTextTheme(),
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
          fontWeight: FontWeight.w700, letterSpacing: -0.2),
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgCard, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border)),
      ),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.bgInput,
        border: AppColors.border,
        focus: AppColors.primary,
        label: AppColors.textSecondary,
        hint: AppColors.textMuted,
        text: AppColors.textPrimary,
      ),
      elevatedButtonTheme: _elevatedBtn(),
      outlinedButtonTheme: _outlinedBtn(),
      textButtonTheme: _textBtn(),
      chipTheme: _chipTheme(
        bg: AppColors.bgCard,
        selected: AppColors.primaryMuted,
        border: AppColors.border,
        label: AppColors.textSecondary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgCard,
        contentTextStyle: AppTextStyles.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary : const Color(0xFF6B7280)),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.4)
            : const Color(0xFF374151)),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.bgCard)),
      ),
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
      textTheme: _lightTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightBgSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        shadowColor: Color(0x0F000000),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextPrimary, fontSize: 18,
          fontWeight: FontWeight.w700, letterSpacing: -0.2),
        iconTheme: IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightBgCard, elevation: 0, margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lightBorder)),
        shadowColor: const Color(0x0A000000),
      ),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.lightBgInput,
        border: AppColors.lightBorder,
        focus: AppColors.primary,
        label: AppColors.lightTextSecondary,
        hint: AppColors.lightTextMuted,
        text: AppColors.lightTextPrimary,
      ),
      elevatedButtonTheme: _elevatedBtn(),
      outlinedButtonTheme: _outlinedBtn(),
      textButtonTheme: _textBtn(),
      chipTheme: _chipTheme(
        bg: AppColors.lightBgCard,
        selected: AppColors.primaryMuted,
        border: AppColors.lightBorder,
        label: AppColors.lightTextSecondary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder, thickness: 1, space: 0),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightBgSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 11, color: AppColors.lightTextMuted),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightBgCard,
        contentTextStyle: const TextStyle(
          color: AppColors.lightTextPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary : const Color(0xFFD1D5DB)),
        trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected)
            ? AppColors.primary.withValues(alpha: 0.35)
            : const Color(0xFFE5E7EB)),
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(
            AppColors.lightBgCard)),
      ),
    );
  }

  // ── Text themes ───────────────────────────────────────────────────
  static TextTheme _darkTextTheme() => const TextTheme(
    displayLarge:  TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w700),
    headlineMedium:TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w600),
    titleLarge:    TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w600),
    titleMedium:   TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w500),
    bodyLarge:     TextStyle(color: AppColors.textPrimary),
    bodyMedium:    TextStyle(color: AppColors.textPrimary),
    bodySmall:     TextStyle(color: AppColors.textSecondary),
    labelLarge:    TextStyle(color: AppColors.textPrimary,
      fontWeight: FontWeight.w600),
    labelMedium:   TextStyle(color: AppColors.textSecondary),
    labelSmall:    TextStyle(color: AppColors.textMuted),
  );

  static TextTheme _lightTextTheme() => const TextTheme(
    displayLarge:  TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w700),
    headlineMedium:TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w600),
    titleLarge:    TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w600),
    titleMedium:   TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w500),
    bodyLarge:     TextStyle(color: AppColors.lightTextPrimary),
    bodyMedium:    TextStyle(color: AppColors.lightTextPrimary),
    bodySmall:     TextStyle(color: AppColors.lightTextSecondary),
    labelLarge:    TextStyle(color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.w600),
    labelMedium:   TextStyle(color: AppColors.lightTextSecondary),
    labelSmall:    TextStyle(color: AppColors.lightTextMuted),
  );

  // ── Shared component factories ────────────────────────────────────
  static InputDecorationTheme _inputTheme({
    required Color fill, required Color border, required Color focus,
    required Color label, required Color hint, required Color text,
  }) => InputDecorationTheme(
    filled: true, fillColor: fill,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: focus, width: 1.5)),
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
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFF4B5563),
        disabledForegroundColor: const Color(0xFF9CA3AF),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.button,
      ),
    );

  static OutlinedButtonThemeData _outlinedBtn() =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
      ),
    );

  static TextButtonThemeData _textBtn() =>
    TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary),
      ),
    );

  static ChipThemeData _chipTheme({
    required Color bg, required Color selected,
    required Color border, required Color label,
  }) => ChipThemeData(
    backgroundColor: bg,
    selectedColor: selected,
    side: BorderSide(color: border),
    labelStyle: TextStyle(color: label, fontSize: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  );
}
