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
    super.key, required this.order, this.isAdmin = false});

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
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Delivery Tracking',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [

          // Order header card
          _Card(isDark: isDark, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.order['id'] ?? '',
              style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            const SizedBox(height: 6),
            Text(widget.order['buyer_name'] ?? '',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(
              '${widget.order['product_type'] ?? ''}  ·  ${widget.order['quality'] ?? ''}',
              style: theme.textTheme.bodySmall),
          ])),
          const SizedBox(height: 16),

          // Progress card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                ? AppColors.primary.withValues(alpha: 0.08)
                : AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.2))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Delivery Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600)),
                Text('${(_pct * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: _pct >= 1 ? AppColors.success : AppColors.primary)),
              ]),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _pct, minHeight: 10,
                  backgroundColor: isDark
                    ? AppColors.bgBase : AppColors.lightBgBase,
                  valueColor: AlwaysStoppedAnimation(
                    _pct >= 1 ? AppColors.success : AppColors.primary))),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _StatPill(
                  label: 'Ordered',
                  value: '${_ordered.toStringAsFixed(0)} MT',
                  color: AppColors.info, isDark: isDark)),
                const SizedBox(width: 10),
                Expanded(child: _StatPill(
                  label: 'Delivered',
                  value: '${_delivered.toStringAsFixed(0)} MT',
                  color: AppColors.success, isDark: isDark)),
                const SizedBox(width: 10),
                Expanded(child: _StatPill(
                  label: 'Remaining',
                  value: '${_remaining.toStringAsFixed(0)} MT',
                  color: _remaining > 0 ? AppColors.warning : AppColors.success,
                  isDark: isDark)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),

          // History header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Delivery History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600)),
            if (widget.isAdmin)
              TextButton.icon(
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Add Entry'),
                onPressed: () => _showAddDelivery(context)),
          ]),
          const SizedBox(height: 12),

          if (_deliveries.isEmpty)
            _Card(isDark: isDark, child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('No deliveries recorded yet.',
                  style: theme.textTheme.bodySmall))))
          else
            ...List.generate(_deliveries.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _DeliveryCard(
                entry: _deliveries[i], index: i + 1,
                isAdmin: widget.isAdmin, isDark: isDark,
                onDelete: () => setState(() => _deliveries.removeAt(i))))),
        ],
      ),
    );
  }

  void _showAddDelivery(BuildContext context) {
    final theme     = Theme.of(context);
    final qtyCtrl   = TextEditingController();
    final dateCtrl  = TextEditingController();
    String? selectedPort;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2)))),
            Text('Add Delivery Entry',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            TextFormField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Quantity Delivered (MT)',
                prefixIcon: Icon(Icons.scale_rounded,
                  size: 18, color: AppColors.textMuted),
                suffixText: 'MT')),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: ctx, initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (c, child) => Theme(
                    data: Theme.of(c).copyWith(
                      colorScheme: const ColorScheme.dark(
                        primary: AppColors.primary)),
                    child: child!));
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
                  color: theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor)),
                child: Row(children: [
                  Icon(Icons.calendar_month_rounded,
                    size: 18,
                    color: AppColors.textMutedColor(context)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    dateCtrl.text.isEmpty
                      ? 'Select Delivery Date' : dateCtrl.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: dateCtrl.text.isEmpty
                        ? AppColors.textMutedColor(context) : null))),
                ]))),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: selectedPort,
              dropdownColor: theme.cardColor,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Port',
                prefixIcon: Icon(Icons.anchor_rounded,
                  size: 18,
                  color: AppColors.textMutedColor(context))),
              items: AppConstants.ports.map((p) => DropdownMenuItem(
                value: p,
                child: Text(p, style: theme.textTheme.bodyMedium))).toList(),
              onChanged: (v) => setModal(() => selectedPort = v)),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final q = double.tryParse(qtyCtrl.text) ?? 0;
                  if (q <= 0 || dateCtrl.text.isEmpty ||
                      selectedPort == null) return;
                  setState(() => _deliveries.add(DeliveryEntry(
                    id: 'D-00${_deliveries.length + 1}',
                    quantity: q, date: dateCtrl.text, port: selectedPort!)));
                  Navigator.pop(ctx);
                },
                child: const Text('Save Delivery'))),
          ]),
        ),
      ),
    );
  }

  String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}

// ── Shared card container ─────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _Card({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? AppColors.bgCard : AppColors.lightBgCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? AppColors.border : AppColors.lightBorder),
      boxShadow: isDark
        ? null
        : [BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6, offset: const Offset(0, 2))]),
    child: child,
  );
}

class _StatPill extends StatelessWidget {
  final String label, value;
  final Color color;
  final bool isDark;
  const _StatPill({
    required this.label, required this.value,
    required this.color, required this.isDark,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: isDark ? 0.12 : 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: color.withValues(alpha: isDark ? 0.3 : 0.2))),
    child: Column(children: [
      Text(value,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
          color: color)),
      const SizedBox(height: 2),
      Text(label,
        style: TextStyle(
          fontSize: 11,
          color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textSecondary : AppColors.lightTextSecondary),
        textAlign: TextAlign.center),
    ]),
  );
}

class _DeliveryCard extends StatelessWidget {
  final DeliveryEntry entry;
  final int index;
  final bool isAdmin, isDark;
  final VoidCallback onDelete;

  const _DeliveryCard({
    required this.entry, required this.index,
    required this.isAdmin, required this.isDark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.border : AppColors.lightBorder),
        boxShadow: isDark
          ? null
          : [BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4, offset: const Offset(0, 1))]),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: isDark ? 0.15 : 0.1),
            borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text('$index',
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: AppColors.success)))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('${entry.quantity.toStringAsFixed(0)} MT  ·  ${entry.port}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(entry.date, style: theme.textTheme.bodySmall),
        ])),
        const Icon(Icons.check_circle_rounded,
          color: AppColors.success, size: 18),
        if (isAdmin) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.delete_outline_rounded,
                size: 15, color: AppColors.error))),
        ],
      ]),
    );
  }
}
