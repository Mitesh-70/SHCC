import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool isAdmin;
  const ProfileScreen({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    const name     = 'Raj Sharma';
    const empId    = 'SHCC-2024-042';
    const role     = 'Sales Staff';
    const region   = 'Surat & South Gujarat';
    const initials = 'RS';

    final target   = TargetStore.targets[name]  ?? 0;
    final achieved = TargetStore.achieved[name] ?? 0;
    final pct = target == 0
      ? 0.0 : (achieved / target).clamp(0.0, 1.0);

    String fmt(double v) {
      if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
      if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
      return '₹${v.toStringAsFixed(0)}';
    }

    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showProfileIcon: false,
        leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              onPressed: () => Navigator.pop(context))
          : null,
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.settings_outlined,
                size: 17, color: AppColors.textSecondary),
            ),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                SettingsScreen(isAdmin: isAdmin))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        children: [

          // Avatar
          Center(child: Column(children: [
            Container(
              width: 88, height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryMuted,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Center(child: Text(initials,
                style: const TextStyle(color: AppColors.primary,
                  fontSize: 28, fontWeight: FontWeight.w800))),
            ),
            const SizedBox(height: 14),
            Text(name, style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(20)),
              child: Text(role, style: const TextStyle(
                color: AppColors.primary, fontSize: 12,
                fontWeight: FontWeight.w600)),
            ),
          ])),
          const SizedBox(height: 28),

          // Info card
          _InfoCard(items: const [
            ('Employee ID', empId),
            ('Region',      region),
            ('Email',       'raj.sharma@shcc.com'),
            ('Phone',       '+91 98765 43210'),
            ('Joined',      'March 2021'),
          ]),
          const SizedBox(height: 20),

          // Target card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const Icon(Icons.track_changes_rounded,
                        size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Monthly Target',
                        style: AppTextStyles.heading3),
                    ]),
                    Text('${(pct * 100).toStringAsFixed(0)}%',
                      style: AppTextStyles.heading3.copyWith(
                        color: pct >= 1
                          ? AppColors.success : AppColors.primary)),
                  ]),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${fmt(achieved)} achieved',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.success)),
                    Text('of ${fmt(target)}',
                      style: AppTextStyles.caption),
                  ]),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: pct, minHeight: 10,
                    backgroundColor: AppColors.bgBase,
                    valueColor: AlwaysStoppedAnimation(
                      pct >= 1 ? AppColors.success : AppColors.primary),
                  ),
                ),
                if (target == 0) ...[
                  const SizedBox(height: 10),
                  Text('No target assigned yet. Contact admin.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Settings shortcut card
          GestureDetector(
            onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                SettingsScreen(isAdmin: isAdmin))),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.settings_outlined,
                    size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings', style: AppTextStyles.bodyMedium),
                    Text('Password, theme, targets',
                      style: AppTextStyles.caption),
                  ],
                )),
                const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              ]),
            ),
          ),
          const SizedBox(height: 32),

          OutlinedButton.icon(
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () =>
              Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<(String, String)> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: items.asMap().entries.map((e) => Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 13),
            child: Row(children: [
              SizedBox(width: 110,
                child: Text(e.value.$1,
                  style: AppTextStyles.caption)),
              Expanded(child: Text(e.value.$2,
                style: AppTextStyles.bodyMedium)),
            ]),
          ),
          if (e.key < items.length - 1)
            const Divider(height: 1, indent: 16, endIndent: 16),
        ])).toList(),
      ),
    );
  }
}
