import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

enum OrderStatus { pending, processed, completed, confirmed, rejected }

class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const StatusBadge({super.key, required this.status});

  factory StatusBadge.fromString(String s) {
    switch (s.toLowerCase()) {
      case 'processed':  return const StatusBadge(status: OrderStatus.processed);
      case 'completed':  return const StatusBadge(status: OrderStatus.completed);
      case 'confirmed':  return const StatusBadge(status: OrderStatus.confirmed);
      case 'rejected':   return const StatusBadge(status: OrderStatus.rejected);
      default:           return const StatusBadge(status: OrderStatus.pending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.35)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (status == OrderStatus.confirmed)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.lock_rounded, size: 9, color: c),
          ),
        Text(_label(), style: AppTextStyles.badge.copyWith(color: c)),
      ]),
    );
  }

  Color _color() {
    switch (status) {
      case OrderStatus.processed:  return AppColors.statusProcessed;
      case OrderStatus.completed:  return AppColors.statusCompleted;
      case OrderStatus.confirmed:  return const Color(0xFF9B59B6);
      case OrderStatus.rejected:   return AppColors.statusRejected;
      default:                     return AppColors.statusPending;
    }
  }

  String _label() {
    switch (status) {
      case OrderStatus.processed:  return 'Processed';
      case OrderStatus.completed:  return 'Completed';
      case OrderStatus.confirmed:  return 'Confirmed';
      case OrderStatus.rejected:   return 'Rejected';
      default:                     return 'Pending';
    }
  }
}
