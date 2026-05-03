import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const target = 5000000.0;
    const achieved = 3100000.0;
    final pct = achieved / target;

    return Scaffold(
      appBar: ShccAppBar(
          logoAsset: 'assets/images/logo.png',showProfileIcon: false,
        leading: Navigator.canPop(context)
          ? IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18), onPressed: () => Navigator.pop(context))
          : null),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 24, 16, 40), children: [
        // Avatar
        Center(child: Column(children: [
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryMuted,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(child: Text('RS',
              style: TextStyle(color: AppColors.primary, fontSize: 28, fontWeight: FontWeight.w800))),
          ),
          const SizedBox(height: 14),
          Text('Raj Sharma', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: AppColors.primaryMuted, borderRadius: BorderRadius.circular(20)),
            child: const Text('Sales Staff', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ])),
        const SizedBox(height: 32),

        // Info card
        _InfoCard(items: const [
          ('Employee ID', 'SHCC-2024-042'),
          ('Region', 'Surat & South Gujarat'),
          ('Email', 'raj.sharma@shcc.com'),
          ('Phone', '+91 98765 43210'),
          ('Joined', 'March 2021'),
        ]),
        const SizedBox(height: 20),

        // Target card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Monthly Target', style: AppTextStyles.heading3),
              Text('${(pct * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('₹${(achieved / 100000).toStringAsFixed(1)}L achieved',
                style: AppTextStyles.caption.copyWith(color: AppColors.success)),
              Text('of ₹${(target / 100000).toStringAsFixed(0)}L', style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: pct, minHeight: 10,
                backgroundColor: AppColors.bgBase,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ]),
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<(String, String)> items;
  const _InfoCard({required this.items});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
      child: Column(children: items.asMap().entries.map((e) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(children: [
            SizedBox(width: 110, child: Text(e.value.$1, style: AppTextStyles.caption)),
            Expanded(child: Text(e.value.$2, style: AppTextStyles.bodyMedium)),
          ]),
        ),
        if (e.key < items.length - 1) const Divider(height: 1, indent: 16, endIndent: 16),
      ])).toList()),
    );
  }
}
