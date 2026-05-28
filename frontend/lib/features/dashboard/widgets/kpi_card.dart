import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class KpiCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final String? sub;

  const KpiCard({
    super.key,
    required this.label, required this.value,
    required this.icon,  required this.color,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // In light mode: clean white card with coloured left accent
    final cardBg = isDark ? AppColors.bgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.border : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: isDark
          ? null
          : [BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ]),
        const Spacer(),
        Text(value,
          style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w700,
            color: color, letterSpacing: -0.5, height: 1.1)),
        const SizedBox(height: 3),
        Text(label,
          style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
        if (sub != null)
          Text(sub!,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400,
              color: isDark ? AppColors.textMuted : AppColors.lightTextMuted)),
      ]),
    );
  }
}
