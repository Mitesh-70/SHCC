import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/app_text_styles.dart';

enum OrderStatus {
  pendingApproval,
  rejected,
  approved,
  onHold,
  dispatched,
  completed,
  // Legacy aliases for backward compatibility
  pending,
  processed,
  confirmed,
}

class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  const StatusBadge({super.key, required this.status});

  factory StatusBadge.fromString(String s) {
    switch (s.toLowerCase()) {
      case AppConstants.statusPendingApproval:
      case 'pending':
        return const StatusBadge(status: OrderStatus.pendingApproval);
      case AppConstants.statusRejected:
        return const StatusBadge(status: OrderStatus.rejected);
      case AppConstants.statusApproved:
      case 'confirmed':
        return const StatusBadge(status: OrderStatus.approved);
      case AppConstants.statusOnHold:
        return const StatusBadge(status: OrderStatus.onHold);
      case AppConstants.statusDispatched:
      case 'processed':
        return const StatusBadge(status: OrderStatus.dispatched);
      case AppConstants.statusCompleted:
        return const StatusBadge(status: OrderStatus.completed);
      default:
        return const StatusBadge(status: OrderStatus.pendingApproval);
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
        if (status == OrderStatus.approved)
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
      case OrderStatus.pendingApproval:
      case OrderStatus.pending:
        return const Color(0xFFEAB308); // amber
      case OrderStatus.approved:
      case OrderStatus.confirmed:
        return const Color(0xFF3B82F6); // blue
      case OrderStatus.onHold:
        return const Color(0xFFF97316); // orange
      case OrderStatus.dispatched:
      case OrderStatus.processed:
        return const Color(0xFF14B8A6); // teal
      case OrderStatus.completed:
        return AppColors.statusCompleted;
      case OrderStatus.rejected:
        return AppColors.statusRejected;
    }
  }

  String _label() {
    switch (status) {
      case OrderStatus.pendingApproval:
      case OrderStatus.pending:
        return 'Pending Approval';
      case OrderStatus.rejected:
        return 'Rejected';
      case OrderStatus.approved:
      case OrderStatus.confirmed:
        return 'Approved';
      case OrderStatus.onHold:
        return 'On Hold';
      case OrderStatus.dispatched:
      case OrderStatus.processed:
        return 'Dispatched';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
}
