import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/status_badge.dart';

class RecentOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  const RecentOrderTile({super.key, required this.order});

  double get _total {
    final base = (order['base_rate'] as num).toDouble();
    final qty  = (order['quantity']  as num).toDouble();
    final gst  = (order['gst']       as num).toDouble();
    final tcs  = (order['tcs']       as num).toDouble();
    final b    = base * qty;
    return b + b * (gst / 100) + b * (tcs / 100);
  }

  String get _totalStr {
    final v = _total;
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(order['id'] ?? '',
            style: AppTextStyles.label.copyWith(color: AppColors.primary)),
          StatusBadge.fromString(order['status'] ?? 'pending'),
        ]),
        const SizedBox(height: 10),
        Text(order['buyer_name'] ?? order['customer'] ?? '',
          style: AppTextStyles.bodyMedium),
        const SizedBox(height: 2),
        Text(
          '${order['quantity'] ?? order['qty'] ?? ''} MT  ·  ${order['type_of_sale'] ?? ''}  ·  ${order['port_name'] ?? ''}',
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_totalStr,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w700)),
          Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(order['date'] ?? '', style: AppTextStyles.caption),
          ]),
        ]),
      ]),
    );
  }
}
