import 'dart:ui';
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
  // Static deliveries cache map to persist tracking records between navigations
  static final Map<String, List<DeliveryEntry>> _deliveriesCache = {};

  late List<DeliveryEntry> _deliveries;
  bool _isAdding = false;
  final _qtyCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  String? _selectedPort;

  @override
  void initState() {
    super.initState();
    final orderId = widget.order['id'] ?? '';
    if (!_deliveriesCache.containsKey(orderId)) {
      if (orderId == 'ORD-2024-048') {
        _deliveriesCache[orderId] = [
          DeliveryEntry(id: 'D-001', quantity: 80,  date: '20 Apr 2024', port: 'Mundra'),
          DeliveryEntry(id: 'D-002', quantity: 60,  date: '24 Apr 2024', port: 'Mundra'),
        ];
      } else {
        _deliveriesCache[orderId] = [];
      }
    }
    _deliveries = _deliveriesCache[orderId]!;
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _resetForm() {
    _qtyCtrl.clear();
    _dateCtrl.clear();
    _selectedPort = null;
  }

  double get _ordered   => (widget.order['quantity'] as num).toDouble();
  double get _delivered => _deliveries.fold(0, (s, d) => s + d.quantity);
  double get _remaining => (_ordered - _delivered).clamp(0, double.infinity);
  double get _pct       => _ordered == 0 ? 0 : (_delivered / _ordered).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isCompleted = _remaining <= 0;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false, // We control the keyboard offset manually for a smoother slide-up transition
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Delivery Tracking',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                20,
                16,
                (_isAdding ? 240.0 : 96.0) + (keyboardHeight > 0 ? keyboardHeight - 40 : 0).clamp(0.0, double.infinity),
              ),
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
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
                            title: Text('Confirm Delete', style: TextStyle(color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                            content: Text('Are you sure you want to delete this delivery entry?', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel', style: TextStyle(color: AppColors.primary)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          setState(() => _deliveries.removeAt(i));
                        }
                      }
                    ))),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: isCompleted
                ? const SizedBox.shrink()
                : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                              .withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          color: isDark
                              ? AppColors.darkBgSurface.withValues(alpha: 0.7)
                              : AppColors.lightBgSurface.withValues(alpha: 0.8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: SafeArea(
                            top: false,
                            child: _isAdding
                                ? _buildExpandedForm(context, isDark, theme)
                                : _buildCollapsedBar(context, isDark, theme),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedBar(BuildContext context, bool isDark, ThemeData theme) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isAdding = true;
        });
      },
      child: Row(
        children: [
          GlowingAddButton(
            onTap: () {
              setState(() {
                _isAdding = true;
              });
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Dispatch Entry',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Log details for the next cargo shipment',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.keyboard_arrow_up_rounded,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
  Widget _buildExpandedForm(BuildContext context, bool isDark, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Dispatch Entry',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  setState(() {
                    _isAdding = false;
                    _resetForm();
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _qtyCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Qty (MT)',
                    labelStyle: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.scale_rounded, size: 16, color: AppColors.primary),
                    suffixText: 'MT',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPort,
                  dropdownColor: theme.cardColor,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    labelStyle: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                    prefixIcon: const Icon(Icons.anchor_rounded, size: 16, color: AppColors.primary),
                  ),
                  items: AppConstants.ports.map((p) => DropdownMenuItem(
                    value: p,
                    child: Text(p, style: theme.textTheme.bodyMedium))).toList(),
                  onChanged: (v) => setState(() => _selectedPort = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                builder: (c, child) => Theme(
                  data: Theme.of(c).copyWith(
                    colorScheme: isDark
                        ? const ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: AppColors.darkBgSurface,
                            onSurface: AppColors.darkTextPrimary,
                          )
                        : const ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                            surface: AppColors.lightBgSurface,
                            onSurface: AppColors.lightTextPrimary,
                          ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                setState(() {
                  _dateCtrl.text =
                    '${picked.day} ${_month(picked.month)} ${picked.year}';
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgInput : AppColors.lightBgInput,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _dateCtrl.text.isEmpty ? 'Select Delivery Date' : _dateCtrl.text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _dateCtrl.text.isEmpty
                            ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GlowingAddButton(
                onTap: () {
                  final q = double.tryParse(_qtyCtrl.text) ?? 0;
                  if (q <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid quantity.')),
                    );
                    return;
                  }
                  if (q > _remaining) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Quantity cannot exceed remaining quantity (${_remaining.toStringAsFixed(0)} MT).')),
                    );
                    return;
                  }
                  if (_selectedPort == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a port.')),
                    );
                    return;
                  }
                  if (_dateCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a delivery date.')),
                    );
                    return;
                  }
                  setState(() {
                    _deliveries.add(DeliveryEntry(
                      id: 'D-00${_deliveries.length + 1}',
                      quantity: q,
                      date: _dateCtrl.text,
                      port: _selectedPort!,
                    ));
                    _isAdding = false;
                    _resetForm();
                  });
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Submit Entry',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}

// ── Glowing Plus Button ───────────────────────────────────────────────────────
class GlowingAddButton extends StatefulWidget {
  final VoidCallback onTap;
  const GlowingAddButton({super.key, required this.onTap});

  @override
  State<GlowingAddButton> createState() => _GlowingAddButtonState();
}

class _GlowingAddButtonState extends State<GlowingAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 2.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.45),
                  blurRadius: _glowAnimation.value * 1.5,
                  spreadRadius: _glowAnimation.value * 0.4,
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }
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