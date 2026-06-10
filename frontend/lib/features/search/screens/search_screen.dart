import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../orders/screens/create_order_screen.dart';
import '../../tracking/order_tracking_screen.dart';

class SearchScreen extends StatefulWidget {
  final bool isAdmin;
  final String? highlightOrderId;

  const SearchScreen({
    super.key,
    this.isAdmin = false,
    this.highlightOrderId,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  String _query  = '';
  // ── Confirmed removed from filter options ─────────────────────────
  String _filter = 'All';

  final Map<String, GlobalKey> _cardKeys = {};

  @override
  void initState() {
    super.initState();
    for (final o in _orders) {
      _cardKeys[o['id'] as String] = GlobalKey();
    }
    if (widget.highlightOrderId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToHighlight());
    }
  }

  @override
  void didUpdateWidget(SearchScreen old) {
    super.didUpdateWidget(old);
    if (widget.highlightOrderId != old.highlightOrderId &&
        widget.highlightOrderId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToHighlight());
    }
  }

  void _scrollToHighlight() {
    final key = _cardKeys[widget.highlightOrderId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut, alignment: 0.2);
    }
  }

  static const _orders = [
    {
      'id': 'ORD-2024-048', 'buyer_name': 'JSW Steel Ltd',
      'sales_person_name': 'Raj Sharma', 'product_type': 'Indonesian Coal',
      'base_rate': 6200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 200.0,
      'type_of_sale': 'Spot', 'quality': '5000 GAR',
      'port_name': 'Mundra', 'payment_terms': 'Advance',
      'status': 'processed', 'date': '28 Apr 2024',
    },
    {
      'id': 'ORD-2024-047', 'buyer_name': 'Ultratech Cement',
      'sales_person_name': 'Raj Sharma', 'product_type': 'South African Coal',
      'base_rate': 6100.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 150.0,
      'type_of_sale': 'F.O.R.', 'quality': '4200 GAR',
      'port_name': 'Kandla', 'payment_terms': 'Credit Line',
      'status': 'pending', 'date': '27 Apr 2024',
      'rejected': true,
      'admin_comment': 'Quantity too high for this port. Reduce to 100 MT.',
    },
    {
      'id': 'ORD-2024-046', 'buyer_name': 'Tata Steel',
      'sales_person_name': 'Amit Patel', 'product_type': 'Russian Coal',
      'base_rate': 5600.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 500.0,
      'type_of_sale': 'Spot', 'quality': '4800 GAR',
      'port_name': 'Hazira', 'payment_terms': 'On Delivery',
      'status': 'processed', 'date': '26 Apr 2024',
    },
    {
      'id': 'ORD-2024-045', 'buyer_name': 'JSW Steel Ltd',
      'sales_person_name': 'Raj Sharma', 'product_type': 'US Coal',
      'base_rate': 3500.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 100.0,
      'type_of_sale': 'F.O.R.', 'quality': '3800 GAR',
      'port_name': 'Magdalla', 'payment_terms': 'Advance',
      'status': 'pending', 'date': '25 Apr 2024',
    },
    {
      'id': 'ORD-2024-044', 'buyer_name': 'ACC Cement',
      'sales_person_name': 'Priya Mehta', 'product_type': 'Indonesian Coal',
      'base_rate': 8200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 300.0,
      'type_of_sale': 'Spot', 'quality': '4500 GAR',
      'port_name': 'Navlakhi', 'payment_terms': 'LC',
      'status': 'completed', 'date': '24 Apr 2024',
    },
  ];

  List<Map<String, dynamic>> get _filtered => _orders.where((o) {
    final q = _query.toLowerCase().trim();
    final matchStatus = _filter == 'All' ||
      (o['status'] as String).toLowerCase() == _filter.toLowerCase();
    if (!matchStatus) return false;
    if (q.isEmpty) return true;
    return [
      o['buyer_name']        as String,
      o['id']                as String,
      o['sales_person_name'] as String,
      o['port_name']         as String,
      o['product_type']      as String,
    ].any((f) => f.toLowerCase().contains(q));
  }).toList();

  bool get _isGrouped => _query.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        onProfileTap: () {},
        userInitials: widget.isAdmin ? 'AD' : 'RS',
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _ctrl,
              style: AppTextStyles.body,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search orders...',
                prefixIcon: Icon(Icons.search_rounded,
                  size: 20, color: AppColors.textMuted),
                suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded,
                        size: 18, color: AppColors.textMuted),
                      onPressed: () => setState(() {
                        _query = ''; _ctrl.clear();
                      }))
                  : null,
              ),
            )),
            const SizedBox(width: 10),
            _FilterBtn(
              isActive: _filter != 'All',
              onTap: () => _showFilter(context),
            ),
          ]),
        ),

        // ── Filter chips — Confirmed removed ─────────────────────
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8),
            children: ['All', 'Pending', 'Processed', 'Completed']
              .map((f) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FChip(
                  label: f.toUpperCase(),
                  selected: _filter == f,
                  onTap: () => setState(() => _filter = f),
                ),
              )).toList(),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
          child: Row(children: [
            Text('${filtered.length} ORDERS FOUND',
              style: AppTextStyles.caption.copyWith(letterSpacing: 1.2, fontWeight: FontWeight.bold)),
            const Spacer(),
            if (widget.highlightOrderId != null) ...[
              // Highlighted text removed
            ],
            if (_isGrouped) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(10)),
                child: Text('Grouped by buyer',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
            ],
            Icon(Icons.sort_rounded, color: AppColors.textSecondary, size: 20),
          ]),
        ),

        Expanded(
          child: filtered.isEmpty
            ? const EmptyState(
                icon: Icons.search_off_rounded,
                title: AppStrings.noResults,
                subtitle: AppStrings.noResultsSub)
            : _isGrouped
              ? _GroupedList(
                  orders: filtered,
                  isAdmin: widget.isAdmin,
                  highlightOrderId: widget.highlightOrderId,
                  cardKeys: _cardKeys,
                )
              : _FlatList(
                  orders: filtered,
                  isAdmin: widget.isAdmin,
                  highlightOrderId: widget.highlightOrderId,
                  cardKeys: _cardKeys,
                ),
        ),
      ]),
    );
  }

  void _showFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter by Status', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            ...['All', 'Pending', 'Processed', 'Completed'].map((f) =>
              ListTile(
                contentPadding: EdgeInsets.zero, dense: true,
                title: Text(f, style: AppTextStyles.body),
                trailing: _filter == f
                  ? const Icon(Icons.check_circle_rounded,
                      color: AppColors.primary, size: 20)
                  : null,
                onTap: () {
                  setState(() => _filter = f);
                  Navigator.pop(context);
                },
              )),
          ],
        ),
      ),
    );
  }
}

class _FlatList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final bool isAdmin;
  final String? highlightOrderId;
  final Map<String, GlobalKey> cardKeys;

  const _FlatList({
    required this.orders,
    required this.isAdmin,
    required this.highlightOrderId,
    required this.cardKeys,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final o = orders[i];
        final id = o['id'] as String;
        return _OrderCard(
          key: cardKeys[id],
          order: o,
          isAdmin: isAdmin,
          isHighlighted: id == highlightOrderId,
        );
      },
    );
  }
}

class _GroupedList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final bool isAdmin;
  final String? highlightOrderId;
  final Map<String, GlobalKey> cardKeys;

  const _GroupedList({
    required this.orders,
    required this.isAdmin,
    required this.highlightOrderId,
    required this.cardKeys,
  });

  @override
  State<_GroupedList> createState() => _GroupedListState();
}

class _GroupedListState extends State<_GroupedList> {
  final Set<String> _collapsed = {};

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final o in widget.orders) {
      grouped.putIfAbsent(o['buyer_name'] as String, () => []).add(o);
    }

    // Auto-expand group containing highlighted order
    if (widget.highlightOrderId != null) {
      for (final e in grouped.entries) {
        final containsHighlight = e.value.any((o) => o['id'] == widget.highlightOrderId);
        if (containsHighlight) {
          _collapsed.remove(e.key);
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        for (final e in grouped.entries) ...[
          GestureDetector(
            onTap: () => setState(() =>
              _collapsed.contains(e.key)
                ? _collapsed.remove(e.key)
                : _collapsed.add(e.key)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(9)),
                  child: const Icon(Icons.business_rounded,
                    size: 17, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key, style: AppTextStyles.bodyMedium),
                    Text('${e.value.length} order${e.value.length == 1 ? '' : 's'}',
                      style: AppTextStyles.caption),
                  ],
                )),
                Icon(
                  _collapsed.contains(e.key)
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_up_rounded,
                  color: AppColors.textMuted),
              ]),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _collapsed.contains(e.key)
              ? const SizedBox(key: ValueKey('hidden'))
              : Column(
                  key: const ValueKey('shown'),
                  children: e.value.map((o) {
                    final id = o['id'] as String;
                    return Padding(
                      padding: const EdgeInsets.only(left: 12, bottom: 8),
                      child: _OrderCard(
                        key: widget.cardKeys[id],
                        order: o,
                        isAdmin: widget.isAdmin,
                        isHighlighted: id == widget.highlightOrderId,
                      ),
                    );
                  }).toList()),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SmallBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withValues(alpha: 0.35)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 10, color: color),
      const SizedBox(width: 3),
      Text(label, style: AppTextStyles.badge.copyWith(color: color)),
    ]),
  );
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isAdmin;
  final bool isHighlighted;

  const _OrderCard({
    super.key,
    required this.order,
    required this.isAdmin,
    this.isHighlighted = false,
  });

  // ── Edit allowed ONLY when status == pending ──────────────────────
  bool get _canEdit => (order['status'] as String) == 'pending';

  // ── Rejected = pending + rejected flag ────────────────────────────
  bool get _isRejected =>
    order['rejected'] == true &&
    (order['status'] as String) == 'pending';

  // ── Delivery tracking for processed/completed ─────────────────────
  bool get _showTracking {
    final s = order['status'] as String;
    return s == 'processed' || s == 'completed';
  }

  double get _total {
    final b = (order['base_rate'] as num).toDouble()
      * (order['quantity'] as num).toDouble();
    return b
      + b * ((order['gst'] as num) / 100)
      + b * ((order['tcs'] as num) / 100);
  }

  String get _totalStr {
    if (_total >= 10000000)
      return '₹${(_total / 10000000).toStringAsFixed(2)} Cr';
    if (_total >= 100000)
      return '₹${(_total / 100000).toStringAsFixed(2)} L';
    return '₹${_total.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = _isRejected
      ? AppColors.error.withValues(alpha: 0.45)
      : isHighlighted
        ? AppColors.primary
        : AppColors.border.withValues(alpha: 0.5);

    final bgColor = _isRejected
      ? AppColors.error.withValues(alpha: 0.02)
      : isHighlighted
        ? AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.06)
        : Theme.of(context).cardColor;

    return GestureDetector(
      onTap: () {
        if (!_canEdit) {
          _showDetail(context);
        } else {
          Navigator.push(context,
            MaterialPageRoute(builder: (_) =>
              CreateOrderScreen(
                prefill: order, isAdmin: isAdmin)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isHighlighted ? 1.5 : 1.0,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(order['id'] as String,
                style: AppTextStyles.label.copyWith(
                  color: AppColors.primary.withValues(alpha: 0.8), letterSpacing: 1.5)),
              Row(children: [
                StatusBadge.fromString(order['status'] as String),
                if (_isRejected) ...[
                  const SizedBox(width: 6),
                  _SmallBadge(
                    icon: Icons.error_outline_rounded,
                    label: 'REJECTED',
                    color: AppColors.error,
                  ),
                ],
                if (isHighlighted) ...[
                  // Highlighted badge removed to prevent overflow
                ],
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Text(order['buyer_name'] as String,
            style: AppTextStyles.heading2),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('QUANTITY', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text('${order['quantity']} MT', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ORIGIN', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text('${order['product_type']}', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PORT', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text('${order['port_name']}', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DATE', style: AppTextStyles.caption.copyWith(letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text('${order['date']}', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
            ],
          ),

          // ── Admin comment for rejected orders ─────────────────────
          if (_isRejected && order['admin_comment'] != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline_rounded,
                        size: 14, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text('ADMIN COMMENT',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(order['admin_comment'] as String,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          Divider(color: AppColors.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_totalStr,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary)),
              Icon(
                _canEdit ? Icons.edit_outlined : Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final b = (order['base_rate'] as num).toDouble()
      * (order['quantity'] as num).toDouble();
    final gstAmt = b * ((order['gst'] as num) / 100);
    final tcsAmt = b * ((order['tcs'] as num) / 100);
    final total  = b + gstAmt + tcsAmt;
    String fmt(double v) {
      if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
      if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
      return '₹${v.toStringAsFixed(2)}';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.78, maxChildSize: 0.95,
        minChildSize: 0.5, expand: false,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
          children: [
            Center(child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2)),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Detail', style: AppTextStyles.heading2),
                    const SizedBox(height: 6),
                    Row(children: [
                      StatusBadge.fromString(order['status'] as String),
                      if (_isRejected) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.error.withValues(
                                alpha: 0.35)),
                          ),
                          child: Text('Rejected',
                            style: AppTextStyles.badge.copyWith(
                              color: AppColors.error)),
                        ),
                      ],
                    ]),
                  ]),
                Row(children: [
                  if (_showTracking)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: OutlinedButton.icon(
                        icon: const Icon(
                          Icons.local_shipping_outlined, size: 15),
                        label: const Text('Track'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) => OrderTrackingScreen(
                              order: order, isAdmin: isAdmin)));
                        },
                      ),
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.receipt_long_rounded, size: 15),
                    label: const Text('Invoice'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8)),
                    onPressed: () {},
                  ),
                ]),
              ],
            ),

            // Admin comment in detail view
            if (_isRejected && order['admin_comment'] != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.admin_panel_settings_outlined,
                      size: 16, color: AppColors.error),
                    const SizedBox(width: 10),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Comment',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error)),
                        const SizedBox(height: 4),
                        Text(order['admin_comment'] as String,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary)),
                      ],
                    )),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            _DSection('Order Info', [
              ('Order ID',     order['id'] as String),
              ('Date',         order['date'] as String),
              ('Sales Person', order['sales_person_name'] as String),
            ]),
            const SizedBox(height: 16),
            _DSection('Product Details', [
              ('Product',      order['product_type'] as String),
              ('Quality',      order['quality'] as String),
              ('Type of Sale', order['type_of_sale'] as String),
              ('Port',         order['port_name'] as String),
              ('Quantity',     '${order['quantity']} MT'),
            ]),
            const SizedBox(height: 16),
            _DSection('Pricing', [
              ('Base Rate', '₹${order['base_rate']}/MT'),
              ('GST',       '${order['gst']}%  →  ${fmt(gstAmt)}'),
              ('TCS',       '${order['tcs']}%  →  ${fmt(tcsAmt)}'),
              ('Total',     fmt(total)),
            ]),
            const SizedBox(height: 16),
            _DSection('Buyer Info', [
              ('Buyer',          order['buyer_name'] as String),
              ('Payment Terms',  order['payment_terms'] as String),
            ]),
          ],
        ),
      ),
    );
  }
}

class _DSection extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;
  const _DSection(this.title, this.rows);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title,
        style: AppTextStyles.label.copyWith(letterSpacing: 0.8)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: AppColors.bgBase,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: rows.asMap().entries.map((e) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 11),
              child: Row(children: [
                SizedBox(width: 110,
                  child: Text(e.value.$1, style: AppTextStyles.caption)),
                Expanded(child: Text(e.value.$2,
                  style: AppTextStyles.bodyMedium)),
              ]),
            ),
            if (e.key < rows.length - 1)
              const Divider(height: 1, indent: 14, endIndent: 14),
          ])).toList(),
        ),
      ),
    ]);
  }
}

class _ABtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  const _ABtn({required this.icon, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? AppColors.textSecondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.bgBase,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: onTap == null ? AppColors.bgBase : AppColors.border),
        ),
        child: Icon(icon, size: 17,
          color: onTap == null ? AppColors.textMuted : resolvedColor),
      ),
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const _FilterBtn({required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 46, height: 48,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryMuted : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border),
      ),
      child: Icon(Icons.tune_rounded,
        color: isActive ? AppColors.primary : AppColors.textSecondary,
        size: 20),
    ),
  );
}

class _FChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FChip({required this.label, required this.selected,
    required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Text(label, style: AppTextStyles.caption.copyWith(
          color: selected ? (isDark ? Colors.black : Colors.white) : AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        )),
      ),
    );
  }
}
