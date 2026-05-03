import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  static const _reports = [
    {'period': 'Today',        'value': '₹8,40,000',  'orders': 4,  'trend': '+12%', 'up': true},
    {'period': 'This Week',    'value': '₹42,00,000', 'orders': 18, 'trend': '+8%',  'up': true},
    {'period': 'This Month',   'value': '₹1,84,00,000','orders': 72, 'trend': '-3%', 'up': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShccAppBar(
          logoAsset: 'assets/images/logo.png',userInitials: 'AD', onProfileTap: () {}),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 24), children: [
        Text('Sales Reports', style: AppTextStyles.heading1),
        const SizedBox(height: 4),
        Text('Analytics overview for your team', style: AppTextStyles.bodySecondary),
        const SizedBox(height: 24),
        ..._reports.map((r) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _ReportCard(report: r),
        )),
      ]),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final up = report['up'] as bool;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(report['period'] as String, style: AppTextStyles.label.copyWith(letterSpacing: 0.8)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: up ? AppColors.successMuted : AppColors.errorMuted,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(up ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 12, color: up ? AppColors.success : AppColors.error),
              const SizedBox(width: 3),
              Text(report['trend'] as String,
                style: AppTextStyles.badge.copyWith(color: up ? AppColors.success : AppColors.error)),
            ]),
          ),
        ]),
        const SizedBox(height: 12),
        Text(report['value'] as String, style: AppTextStyles.kpiValue),
        const SizedBox(height: 4),
        Text('${report['orders']} orders', style: AppTextStyles.caption),
        const SizedBox(height: 16),

        // Mini trend bars (decorative)
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(12, (i) {
          final h = 8.0 + (i % 5) * 8 + (i == 10 ? 16 : 0);
          return Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: i == 11 ? AppColors.primary : AppColors.primary.withValues(alpha: 0.2 + i * 0.04),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ));
        })),
        const SizedBox(height: 16),

        SizedBox(width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.download_outlined, size: 16),
            label: const Text('Generate Report'),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report exported as PDF'))),
          )),
      ]),
    );
  }
}
