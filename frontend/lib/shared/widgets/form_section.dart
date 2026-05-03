import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const FormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Text(title, style: AppTextStyles.heading3),
      ]),
      const SizedBox(height: 2),
      Container(
        margin: const EdgeInsets.only(left: 38),
        height: 1,
        color: AppColors.border,
      ),
      const SizedBox(height: 16),
      ...children,
    ]);
  }
}
