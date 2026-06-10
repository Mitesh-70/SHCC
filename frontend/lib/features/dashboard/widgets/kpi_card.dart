import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// A compact KPI tile matching the reports-section style:
///   ┌──────────────────────────────┐
///   │  LABEL (small caps, top)     │
///   │  [icon]  VALUE (large font)  │
///   └──────────────────────────────┘
class KpiCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  /// Optional: if provided, renders a compact progress bar instead of value text
  final double? progressValue;    // 0.0 – 1.0
  final String? progressLabel;   // e.g. "67% of target"

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.progressValue,
    this.progressLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border  = isDark ? AppColors.border : AppColors.lightBorder;
    final labelColor = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        // Subtle tinted gradient echoing the reports cards
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.14 : 0.10),
            color.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Label (top) ────────────────────────────────────────────
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.9,
              color: labelColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // ── Icon + Value row ────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // ── Optional progress bar (sales target card) ───────────────
          if (progressValue != null) ...[
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressValue!.clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: color.withValues(alpha: 0.15),
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ),
                if (progressLabel != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    progressLabel!,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
