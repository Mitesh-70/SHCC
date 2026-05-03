import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class SyncStatusBadge extends StatelessWidget {
  final String status;
  const SyncStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: cfg.$1.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cfg.$1.withValues(alpha: 0.35)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (status == 'syncing')
          SizedBox(width: 9, height: 9,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: cfg.$1))
        else
          Icon(cfg.$2, size: 9, color: cfg.$1),
        const SizedBox(width: 4),
        Text(cfg.$3, style: AppTextStyles.badge.copyWith(color: cfg.$1)),
      ]),
    );
  }

  (Color, IconData, String) _cfg() {
    switch (status) {
      case 'synced':  return (AppColors.syncSynced,  Icons.check_circle_outline, 'Synced');
      case 'syncing': return (AppColors.syncSyncing, Icons.sync,                 'Syncing');
      case 'failed':  return (AppColors.syncFailed,  Icons.error_outline,        'Failed');
      default:        return (AppColors.syncPending,  Icons.schedule,             'Pending');
    }
  }
}
