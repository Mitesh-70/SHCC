import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/sync_status_badge.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(order['id'] ?? '', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            SyncStatusBadge(status: order['status'] ?? 'pending'),
          ]),
          const SizedBox(height: 8),
          Text(order['customer'] ?? '', style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Text(order['product'] ?? '', style: AppTextStyles.bodySecondary),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.scale_outlined, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(order['qty'] ?? '', style: AppTextStyles.caption),
          ]),
        ]),
      ),
    );
  }
}
