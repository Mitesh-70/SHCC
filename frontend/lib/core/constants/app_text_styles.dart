import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {


  static const TextStyle display = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.2,
  );
  static const TextStyle heading1 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.3, height: 1.3,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: -0.2, height: 1.3,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.textPrimary, letterSpacing: -0.1, height: 1.4,
  );
  static const TextStyle body = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textPrimary, height: 1.5,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w500,
    color: AppColors.textPrimary, height: 1.5,
  );
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, height: 1.4,
  );
  static const TextStyle label = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    color: AppColors.textSecondary, letterSpacing: 0.8, height: 1.3,
  );
  static const TextStyle button = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w600,
    color: Colors.white, letterSpacing: 0.1,
  );
  static const TextStyle kpiValue = TextStyle(
    fontSize: 26, fontWeight: FontWeight.w700,
    color: AppColors.textPrimary, letterSpacing: -0.5, height: 1.1,
  );
  static const TextStyle badge = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w600,
    letterSpacing: 0.3, height: 1.2,
  );
}
