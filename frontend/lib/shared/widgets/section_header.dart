import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading3),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(children: [
              Text(actionLabel!, style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
              const SizedBox(width: 2),
              const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primary),
            ]),
          ),
      ],
    );
  }
}
