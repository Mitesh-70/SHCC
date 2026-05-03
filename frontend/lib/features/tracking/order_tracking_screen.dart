import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/order_model.dart';
import '../../shared/widgets/shcc_app_bar.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Map<String, dynamic> order;
  final bool isAdmin;

  const OrderTrackingScreen({
    super.key, required this.order, this.isAdmin = false,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final List<DeliveryEntry> _deliveries = [
    DeliveryEntry(id: 'D-001', quantity: 80,  date: '20 Apr 2024', port: 'Mundra'),
    DeliveryEntry(id: 'D-002', quantity: 60,  date: '24 Apr 2024', port: 'Mundra'),
  ];

  double get _ordered   => (widget.order['quantity'] as num).toDouble();
  double get _delivered => _deliveries.fold(0, (s, d) => s + d.quantity);
  double get _remaining => (_ordered - _delivered).clamp(0, double.infinity);
  double get _pct       => _ordered == 0 ? 0 : (_delivered / _ordered).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Delivery Tracking',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.order['id'] ?? '',
                style: AppTextStyles.label.copyWith(color: AppColors.primary)),
              const SizedBox(height: 6),
              Text(widget.order['buyer_name'] ?? '',
                style: AppTextStyles.heading3),
              const SizedBox(height: 2),
              Text(
                '${widget.order['product_type'] ?? ''}  ·  ${widget.order['quality'] ?? ''}',
                style: AppTextStyles.caption),
            ]),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Delivery Progress', style: AppTextStyles.heading3),
                Text('${(_pct * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primary)),
              ]),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _pct,
                  minHeight: 10,
                  backgroundColor: AppColors.bgBase,
                  valueColor: AlwaysStoppedAnimation(
                    _pct >= 1 ? AppColors.success : AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _StatPill(
                  label: 'Ordered',
                  statValue: '${_ordered.toStringAsFixed(0)} MT',
                  color: AppColors.info,
                )),
                const SizedBox(width: 10),
                Expanded(child: _StatPill(
                  label: 'Delivered',
                  statValue: '${_delivered.toStringAsFixed(0)} MT',
                  color: AppColors.success,
                )),
                const SizedBox(width: 10),
                Expanded(child: _StatPill(
                  label: 'Remaining',
                  statValue: '${_remaining.toStringAsFixed(0)} MT',
                  color: _remaining > 0 ? AppColors.warning : AppColors.success,
                )),
              ]),
            ]),
          ),
          const SizedBox(height: 28),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Delivery History', style: AppTextStyles.heading3),
            if (widget.isAdmin)
              TextButton.icon(
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Entry'),
                onPressed: () => _showAddDelivery(context),
              ),
          ]),
          const SizedBox(height: 12),

          if (_deliveries.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Text('No deliveries recorded yet.',
                  style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ...List.generate(_deliveries.length, (i) => _DeliveryCard(
              entry: _deliveries[i],
              index: i + 1,
              isAdmin: widget.isAdmin,
              onDelete: () => setState(() => _deliveries.removeAt(i)),
            )),
        ],
      ),
    );
  }

  void _showAddDelivery(BuildContext context) {
    final qtyCtrl  = TextEditingController();
    final dateCtrl = TextEditingController();
    String? selectedPort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(
                width: 36, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2)),
              )),
              Text('Add Delivery Entry', style: AppTextStyles.heading3),
              const SizedBox(height: 20),

              TextFormField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Quantity Delivered (MT)',
                  prefixIcon: Icon(Icons.scale_rounded,
                    size: 18, color: AppColors.textMuted),
                  suffixText: 'MT',
                ),
              ),
              const SizedBox(height: 14),

              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                    builder: (c, child) => Theme(
                      data: Theme.of(c).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.primary)),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    dateCtrl.text =
                      '${picked.day} ${_month(picked.month)} ${picked.year}';
                    setModal(() {});
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.bgInput,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(children: [
                    const Icon(Icons.calendar_month_rounded,
                      size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 12),
                    Expanded(child: Text(
                      dateCtrl.text.isEmpty
                        ? 'Select Delivery Date'
                        : dateCtrl.text,
                      style: AppTextStyles.body.copyWith(
                        color: dateCtrl.text.isEmpty
                          ? AppColors.textMuted
                          : AppColors.textPrimary),
                    )),
                  ]),
                ),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: selectedPort,
                dropdownColor: AppColors.bgCard,
                style: AppTextStyles.body,
                decoration: const InputDecoration(
                  labelText: 'Port',
                  prefixIcon: Icon(Icons.anchor_rounded,
                    size: 18, color: AppColors.textMuted),
                ),
                items: AppConstants.ports
                  .map((p) => DropdownMenuItem<String>(
                    value: p,
                    child: Text(p, style: AppTextStyles.body),
                  )).toList(),
                onChanged: (v) => setModal(() => selectedPort = v),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final q = double.tryParse(qtyCtrl.text) ?? 0;
                    if (q <= 0 || dateCtrl.text.isEmpty ||
                        selectedPort == null) return;
                    setState(() => _deliveries.add(DeliveryEntry(
                      id: 'D-00${_deliveries.length + 1}',
                      quantity: q,
                      date: dateCtrl.text,
                      port: selectedPort!,
                    )));
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save Delivery'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}

class _StatPill extends StatelessWidget {
  final String label, statValue;
  final Color color;
  const _StatPill({
    required this.label,
    required this.statValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Text(statValue,
          style: AppTextStyles.bodyMedium.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center),
      ]),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final DeliveryEntry entry;
  final int index;
  final bool isAdmin;
  final VoidCallback onDelete;

  const _DeliveryCard({
    required this.entry,
    required this.index,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.successMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Text('$index',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.success))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry.quantity.toStringAsFixed(0)} MT  ·  ${entry.port}',
              style: AppTextStyles.bodyMedium),
            const SizedBox(height: 3),
            Text(entry.date, style: AppTextStyles.caption),
          ],
        )),
        const Icon(Icons.check_circle_rounded,
          color: AppColors.success, size: 18),
        if (isAdmin) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.errorMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                size: 15, color: AppColors.error),
            ),
          ),
        ],
      ]),
    );
  }
}
