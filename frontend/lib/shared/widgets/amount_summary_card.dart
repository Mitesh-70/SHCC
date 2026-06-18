import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class AmountSummaryCard extends StatelessWidget {
  final double baseRate;
  final double quantity;
  final double freight;
  final double gst;
  final double tcs;

  const AmountSummaryCard({
    super.key,
    required this.baseRate,
    required this.quantity,
    required this.freight,
    required this.gst,
    required this.tcs,
  });

  double get baseAmount => baseRate * quantity;
  double get gstAmount  => baseAmount * (gst / 100);
  double get tcsAmount  => baseAmount * (tcs / 100);
  double get total      => baseAmount + freight + gstAmount + tcsAmount;

  String _fmt(double v) {
    if (v == 0) return '—';
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.primary.withValues(alpha: 0.05)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: Column(children: [
        _Row('Base Amount', _fmt(baseAmount), isHeader: false),
        const SizedBox(height: 10),
        _Row('Freight', _fmt(freight), isHeader: false),
        const SizedBox(height: 10),
        _Row('GST (${gst.toStringAsFixed(1)}%)', _fmt(gstAmount), isHeader: false),
        const SizedBox(height: 10),
        _Row('TCS (${tcs.toStringAsFixed(1)}%)', _fmt(tcsAmount), isHeader: false),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Container(height: 1, color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Total Amount', style: AppTextStyles.heading3),
          Text(_fmt(total),
            style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
        ]),
      ]),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool isHeader;
  const _Row(this.label, this.value, {required this.isHeader});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.bodySecondary),
      Text(value,  style: AppTextStyles.bodyMedium),
    ]);
  }
}
