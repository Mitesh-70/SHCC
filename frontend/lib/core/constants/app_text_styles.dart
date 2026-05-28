import 'package:flutter/material.dart';
import '../../app.dart';
import 'app_colors.dart';

class AppTextStyles {
  static bool get _isDark => themeNotifier.value == ThemeMode.dark;
  static Color get _textPrimary => _isDark ? AppColors.textPrimary : AppColors.lightTextPrimary;
  static Color get _textSecondary => _isDark ? AppColors.textSecondary : AppColors.lightTextSecondary;

  static TextStyle get display => TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: _textPrimary, letterSpacing: -0.5, height: 1.2,
  );
  static TextStyle get heading1 => TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: _textPrimary, letterSpacing: -0.3, height: 1.3,
  );
  static TextStyle get heading2 => TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: _textPrimary, letterSpacing: -0.2, height: 1.3,
  );
  static TextStyle get heading3 => TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: _textPrimary, letterSpacing: -0.1, height: 1.4,
  );
  static TextStyle get body => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: _textPrimary, height: 1.5,
  );
  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: _textPrimary, height: 1.5,
  );
  static TextStyle get bodySecondary => TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: _textSecondary, height: 1.5,
  );
  static TextStyle get caption => TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: _textSecondary, height: 1.4,
  );
  static TextStyle get label => TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    color: _textSecondary, letterSpacing: 0.8, height: 1.3,
  );
  static TextStyle get button => const TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: Colors.white, letterSpacing: 0.1,
  );
  static TextStyle get kpiValue => TextStyle(
    fontSize: 26, fontWeight: FontWeight.w700,
    color: _textPrimary, letterSpacing: -0.5, height: 1.1,
  );
  static TextStyle get badge => const TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    letterSpacing: 0.3, height: 1.2,
  );
}
