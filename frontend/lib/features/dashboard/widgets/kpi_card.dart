import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class KpiCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final String? sub;

  const KpiCard({
    super.key, required this.label, required this.value,
    required this.icon, required this.color, this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Container(width: 6, height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        ]),
        const Spacer(),
        Text(value, style: AppTextStyles.kpiValue.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
        if (sub != null) Text(sub!, style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 10)),
      ]),
    );
  }
}
