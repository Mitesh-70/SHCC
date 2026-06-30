import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';
import '../../../data/models/order_model.dart';
import '../../../data/order_store.dart';
import '../../../data/stock_store.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../notifications/notifications_screen.dart';
import '../../tracking/order_tracking_screen.dart' show GlowingAddButton;

class PortAdminOrderDetailScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const PortAdminOrderDetailScreen({super.key, required this.order});

  @override
  State<PortAdminOrderDetailScreen> createState() =>
      _PortAdminOrderDetailScreenState();
}

class _PortAdminOrderDetailScreenState
    extends State<PortAdminOrderDetailScreen> {
  late Map<String, dynamic> _order;
  late List<DeliveryEntry> _deliveries;
  bool _isAdding = false;
  final _qtyCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _holdReasonCtrl = TextEditingController();
  String? _selectedPort;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final id = widget.order['id'] as String;
    _order = OrderStore.getOrderById(id) ?? widget.order;
    _deliveries = List.from(OrderStore.getDispatchEntries(id));
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _dateCtrl.dispose();
    _holdReasonCtrl.dispose();
    super.dispose();
  }

  double get _ordered => (_order['quantity'] as num).toDouble();
  double get _delivered => _deliveries.fold(0.0, (s, d) => s + d.quantity);
  double get _remaining => (_ordered - _delivered).clamp(0, double.infinity);
  double get _pct => _ordered == 0 ? 0 : (_delivered / _ordered).clamp(0, 1);

  double get _total {
    final b = (_order['base_rate'] as num).toDouble() * _ordered;
    final f = ((_order['freight'] ?? 0.0) as num).toDouble();
    return b +
        f +
        b * ((_order['gst'] as num) / 100) +
        b * ((_order['tcs'] as num) / 100);
  }

  String get _status => _order['status'] as String;

  bool get _canDispatch =>
      _status == AppConstants.statusApproved ||
      _status == AppConstants.statusDispatched;

  bool get _canHold => _status == AppConstants.statusApproved;
  bool get _canRelease => _status == AppConstants.statusOnHold;
  bool get _canComplete => _status == AppConstants.statusDispatched;

  void _notify({
    required NotifType type,
    required String title,
    required String description,
    String? adminDesc,
    String? spDesc,
    String? paDesc,
  }) {
    final id = _order['id'] as String;
    final salesman = _order['sales_person_name'] as String;
    
    NotificationStore.add(
      person: salesman,
      title: title,
      description: spDesc ?? description,
      type: type,
      orderId: id,
    );
    NotificationStore.add(
      person: 'Admin',
      roles: ['admin'],
      title: title,
      description: adminDesc ?? description,
      type: type,
      orderId: id,
    );
    NotificationStore.notifyPortAdminsForOrder(
      order: _order,
      title: title,
      description: paDesc ?? description,
      type: type,
    );
  }

  Future<void> _putOnHold() async {
    _holdReasonCtrl.clear();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
          title: const Text('Put Order On Hold'),
          content: TextField(
            controller: _holdReasonCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Hold Reason (required)',
              hintText: 'Explain why this order is being held…',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_holdReasonCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx, _holdReasonCtrl.text.trim());
              },
              child: const Text('Confirm Hold'),
            ),
          ],
        );
      },
    );
    if (reason == null || reason.isEmpty) return;

    OrderStore.updateOrderStatus(
      _order['id'] as String,
      AppConstants.statusOnHold,
      holdReason: reason,
    );
    _notify(
      type: NotifType.orderOnHold,
      title: 'Order On Hold',
      description: 'Order ${_order['id']} placed on hold. Reason: $reason',
      adminDesc: 'Port Admin placed order ${_order['id']} on hold. Reason: $reason',
      spDesc: 'Your order ${_order['id']} has been placed on hold. Reason: $reason',
      paDesc: 'Order ${_order['id']} placed on hold. Reason: $reason',
    );
    setState(_refresh);
  }

  void _releaseHold() {
    OrderStore.updateOrderStatus(
      _order['id'] as String,
      AppConstants.statusApproved,
    );
    _notify(
      type: NotifType.holdReleased,
      title: 'Hold Released',
      description: 'Order ${_order['id']} hold has been released.',
      adminDesc: 'Port Admin released hold for order ${_order['id']}.',
      spDesc: 'Your order ${_order['id']} hold has been released.',
      paDesc: 'Order ${_order['id']} hold has been released.',
    );
    setState(_refresh);
  }

  void _markCompleted() {
    OrderStore.updateOrderStatus(
      _order['id'] as String,
      AppConstants.statusCompleted,
    );
    _notify(
      type: NotifType.dispatchUpdated,
      title: 'Delivery Completed',
      description: 'Order ${_order['id']} marked as completed.',
      adminDesc: 'Delivery completed for order ${_order['id']}.',
      spDesc: 'Your order ${_order['id']} delivery has been completed.',
      paDesc: 'Delivery completed for order ${_order['id']}.',
    );
    setState(_refresh);
  }

  void _addDispatch() {
    final q = double.tryParse(_qtyCtrl.text) ?? 0;
    if (q <= 0 || q > _remaining || _selectedPort == null || _dateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all dispatch fields correctly.')),
      );
      return;
    }
    final id = _order['id'] as String;
    final coalType = _order['product_type'] as String? ?? '';
    final availableStock = StockStore.getStock(_selectedPort!, coalType);
    if (q > availableStock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient stock at $_selectedPort. Available: ${availableStock.toStringAsFixed(0)} MT.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final isFirstDispatch = OrderStore.getDispatchEntries(id).isEmpty;
    OrderStore.addDispatchEntry(
      id,
      DeliveryEntry(
        id: 'D-${DateTime.now().millisecondsSinceEpoch}',
        quantity: q,
        date: _dateCtrl.text,
        port: _selectedPort!,
      ),
    );
    _notify(
      type: NotifType.dispatchUpdated,
      title: isFirstDispatch ? 'Dispatch Started' : 'Dispatch Updated',
      description: 'Dispatch entry added for order $id ($q MT).',
      adminDesc: isFirstDispatch
          ? 'Port Admin started dispatch process for order $id ($q MT).'
          : 'Dispatch entry added for order $id ($q MT).',
      spDesc: isFirstDispatch
          ? 'Dispatch started for your order $id ($q MT).'
          : 'Dispatch updated for your order $id ($q MT).',
      paDesc: isFirstDispatch
          ? 'Dispatch started for order $id ($q MT).'
          : 'Dispatch entry added for order $id ($q MT).',
    );
    _qtyCtrl.clear();
    _dateCtrl.clear();
    _selectedPort = null;
    _isAdding = false;
    setState(_refresh);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Order Detail',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16, 20, 16,
                (_isAdding && _canDispatch ? 260.0 : 120.0) +
                    keyboardHeight.clamp(0, double.infinity),
              ),
              children: [
                _headerCard(isDark),
                const SizedBox(height: 16),
                _lockedCommercialCard(isDark),
                const SizedBox(height: 16),
                if (_order['hold_reason'] != null) ...[
                  _infoBanner(
                    'On Hold: ${_order['hold_reason']}',
                    AppColors.warning,
                    isDark,
                  ),
                  const SizedBox(height: 16),
                ],
                _progressCard(theme, isDark),
                const SizedBox(height: 16),
                _actionButtons(isDark),
                const SizedBox(height: 24),
                Text('Dispatch History',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (_deliveries.isEmpty)
                  Text('No dispatch entries yet.',
                      style: theme.textTheme.bodySmall)
                else
                  ..._deliveries.map((d) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _dispatchTile(d, isDark),
                      )),
              ],
            ),
          ),
          if (_canDispatch && _remaining > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: keyboardHeight,
              child: _dispatchBar(theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _headerCard(bool isDark) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_order['id'] as String,
                    style: AppTextStyles.label.copyWith(color: AppColors.primary)),
                StatusBadge.fromString(_status),
              ],
            ),
            const SizedBox(height: 8),
            Text(_order['buyer_name'] as String, style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(
              '${_order['product_type']}  ·  ${_order['quality']}  ·  ${_order['port_name']}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );

  Widget _lockedCommercialCard(bool isDark) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _lockedRow('Buyer', _order['buyer_name'] as String),
            _lockedRow('Base Rate', '₹${_order['base_rate']}/MT'),
            _lockedRow('Quantity', '${_order['quantity']} MT'),
            _lockedRow('Freight', '₹${_order['freight']}'),
            _lockedRow('GST', '${_order['gst']}%'),
            _lockedRow('TCS', '${_order['tcs']}%'),
            _lockedRow('Total', '₹${_total.toStringAsFixed(0)}',
                highlight: true),
            _lockedRow('Payment', _order['payment_terms'] as String),
            _lockedRow('Sales Person', _order['sales_person_name'] as String),
          ],
        ),
      );

  Widget _lockedRow(String label, String value, {bool highlight = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.caption),
            Text(value,
                style: highlight
                    ? AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w700, color: AppColors.primary)
                    : AppTextStyles.bodyMedium),
          ],
        ),
      );

  Widget _progressCard(ThemeData theme, bool isDark) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dispatch Progress',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('${(_pct * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _pct >= 1 ? AppColors.success : AppColors.primary)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _pct,
                minHeight: 8,
                backgroundColor: isDark ? AppColors.bgBase : AppColors.lightBgBase,
                valueColor: AlwaysStoppedAnimation(
                    _pct >= 1 ? AppColors.success : AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${_delivered.toStringAsFixed(0)} / ${_ordered.toStringAsFixed(0)} MT dispatched',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );

  Widget _actionButtons(bool isDark) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_canHold)
            _actionChip('On Hold', Icons.pause_circle_outline, _putOnHold,
                AppColors.warning),
          if (_canRelease)
            _actionChip('Release Hold', Icons.play_circle_outline, _releaseHold,
                AppColors.success),
          if (_canComplete)
            _actionChip('Mark Completed', Icons.check_circle_outline,
                _markCompleted, AppColors.success),
        ],
      );

  Widget _actionChip(
      String label, IconData icon, VoidCallback onTap, Color color) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
    );
  }

  Widget _infoBanner(String text, Color color, bool isDark) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: AppTextStyles.caption)),
          ],
        ),
      );

  Widget _dispatchTile(DeliveryEntry d, bool isDark) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_shipping_outlined,
                color: AppColors.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text('${d.quantity} MT  ·  ${d.port}  ·  ${d.date}',
                  style: AppTextStyles.bodyMedium),
            ),
          ],
        ),
      );

  Widget _dispatchBar(ThemeData theme, bool isDark) => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            color: isDark
                ? AppColors.darkBgSurface.withValues(alpha: 0.85)
                : AppColors.lightBgSurface.withValues(alpha: 0.9),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: _isAdding
                  ? _expandedDispatchForm(theme, isDark)
                  : GestureDetector(
                      onTap: () => setState(() => _isAdding = true),
                      child: Row(
                        children: [
                          GlowingAddButton(
                              onTap: () => setState(() => _isAdding = true)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text('Add Dispatch Entry',
                                style: AppTextStyles.bodyMedium
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      );

  Widget _expandedDispatchForm(ThemeData theme, bool isDark) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Add Dispatch Entry',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => setState(() {
                  _isAdding = false;
                  _qtyCtrl.clear();
                  _dateCtrl.clear();
                  _selectedPort = null;
                }),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qtyCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Qty (MT)',
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedPort,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    isDense: true,
                  ),
                  items: AppSession.instance.assignedPorts
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedPort = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              );
              if (picked != null) {
                setState(() {
                  _dateCtrl.text =
                      '${picked.day} ${_month(picked.month)} ${picked.year}';
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Delivery Date',
                isDense: true,
              ),
              child: Text(_dateCtrl.text.isEmpty
                  ? 'Select date'
                  : _dateCtrl.text),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _addDispatch,
              child: const Text('Submit Dispatch'),
            ),
          ),
        ],
      );

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m];
}
