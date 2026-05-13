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
  final _ctrl   = TextEditingController();
  String _query  = '';
  String _filter = 'All';

  final Map<String, GlobalKey> _cardKeys = {};

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
  bool get _isFiltered => _filter != 'All';

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

  // ── Filter bottom sheet ────────────────────────────────────────────
  void _showFilter(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Drag handle
            Center(child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2)),
            )),
            const SizedBox(height: 20),
            Row(children: [
              Text('Filter Orders', style: AppTextStyles.heading3),
              const Spacer(),
              if (_filter != 'All')
                TextButton(
                  onPressed: () {
                    setState(() => _filter = 'All');
                    setModal(() {});
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Clear',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error)),
                ),
            ]),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: ['All', 'Pending', 'Processed', 'Completed']
                .map((f) {
                  final sel = _filter == f;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _filter = f);
                      setModal(() {});
                      Navigator.pop(ctx);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: sel
                          ? AppColors.primary : theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel
                            ? AppColors.primary : theme.dividerColor),
                      ),
                      child: Text(f,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: sel ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                          fontWeight: sel
                            ? FontWeight.w600 : FontWeight.w400)),
                    ),
                  );
                }).toList(),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final isDark  = theme.brightness == Brightness.dark;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        onProfileTap: () {},
        userInitials: widget.isAdmin ? 'AD' : 'RS',
      ),
      body: Column(children: [

        // ── Search bar (single row, no permanent chips) ────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _ctrl,
                style: theme.textTheme.bodyMedium,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search orders…',
                  prefixIcon: Icon(Icons.search_rounded, size: 20,
                    color: isDark
                      ? AppColors.textMuted : AppColors.lightTextMuted),
                  suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, size: 18,
                          color: isDark
                            ? AppColors.textMuted : AppColors.lightTextMuted),
                        onPressed: () =>
                          setState(() { _query = ''; _ctrl.clear(); }))
                    : null,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Filter button — shows active dot if filter applied
            GestureDetector(
              onTap: () => _showFilter(context),
              child: Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 46, height: 48,
                  decoration: BoxDecoration(
                    color: _isFiltered
                      ? AppColors.primaryMuted : theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isFiltered
                        ? AppColors.primary : theme.dividerColor),
                  ),
                  child: Icon(Icons.tune_rounded,
                    size: 20,
                    color: _isFiltered
                      ? AppColors.primary
                      : (isDark
                          ? AppColors.textSecondary
                          : AppColors.lightTextSecondary)),
                ),
                if (_isFiltered)
                  Positioned(
                    top: -3, right: -3,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 1.5)),
                    ),
                  ),
              ]),
            ),
          ]),
        ),

        // ── Active filter + count row ──────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(children: [
            Text(
              '${filtered.length} order${filtered.length == 1 ? '' : 's'}',
              style: theme.textTheme.bodySmall),
            const SizedBox(width: 8),
            if (_isFiltered)
              GestureDetector(
                onTap: () => setState(() => _filter = 'All'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(_filter,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    const Icon(Icons.close_rounded,
                      size: 11, color: AppColors.primary),
                  ]),
                ),
              ),
            if (widget.highlightOrderId != null && !_isFiltered) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Highlighted',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary)),
              ),
            ],
            if (_isGrouped && !_isFiltered) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(20)),
                child: Text('Grouped',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary)),
              ),
            ],
          ]),
        ),

        // ── Results list ───────────────────────────────────────────
        Expanded(
          child: filtered.isEmpty
            ? const EmptyState(
                icon: Icons.search_off_rounded,
                title: AppStrings.noResults,
                subtitle: AppStrings.noResultsSub)
            : _isGrouped
              ? _GroupedList(
                  orders: filtered, isAdmin: widget.isAdmin,
                  highlightOrderId: widget.highlightOrderId,
                  cardKeys: _cardKeys)
              : _FlatList(
                  orders: filtered, isAdmin: widget.isAdmin,
                  highlightOrderId: widget.highlightOrderId,
                  cardKeys: _cardKeys),
        ),
      ]),
    );
  }
}

// ── Flat list ─────────────────────────────────────────────────────────────────
class _FlatList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final bool isAdmin;
  final String? highlightOrderId;
  final Map<String, GlobalKey> cardKeys;

  const _FlatList({
    required this.orders, required this.isAdmin,
    required this.highlightOrderId, required this.cardKeys,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _OrderCard(
        key: cardKeys[orders[i]['id']],
        order: orders[i], isAdmin: isAdmin,
        isHighlighted: orders[i]['id'] == highlightOrderId,
      ),
    );
  }
}

// ── Grouped list ──────────────────────────────────────────────────────────────
class _GroupedList extends StatefulWidget {
  final List<Map<String, dynamic>> orders;
  final bool isAdmin;
  final String? highlightOrderId;
  final Map<String, GlobalKey> cardKeys;

  const _GroupedList({
    required this.orders, required this.isAdmin,
    required this.highlightOrderId, required this.cardKeys,
  });

  @override
  State<_GroupedList> createState() => _GroupedListState();
}

class _GroupedListState extends State<_GroupedList> {
  final Set<String> _collapsed = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final o in widget.orders) {
      grouped.putIfAbsent(o['buyer_name'] as String, () => []).add(o);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        for (final e in grouped.entries) ...[
          GestureDetector(
            onTap: () => setState(() => _collapsed.contains(e.key)
              ? _collapsed.remove(e.key) : _collapsed.add(e.key)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
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
                    Text(e.key,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                    Text(
                      '${e.value.length} order${e.value.length == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall),
                  ],
                )),
                Icon(_collapsed.contains(e.key)
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
                  color: theme.brightness == Brightness.dark
                    ? AppColors.textMuted : AppColors.lightTextMuted),
              ]),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _collapsed.contains(e.key)
              ? const SizedBox(key: ValueKey('h'))
              : Column(
                  key: const ValueKey('s'),
                  children: e.value.map((o) => Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: _OrderCard(
                      key: widget.cardKeys[o['id']],
                      order: o, isAdmin: widget.isAdmin,
                      isHighlighted: o['id'] == widget.highlightOrderId,
                    ),
                  )).toList()),
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

// ── Order card ────────────────────────────────────────────────────────────────
class _OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final bool isAdmin, isHighlighted;

  const _OrderCard({
    super.key,
    required this.order, required this.isAdmin,
    this.isHighlighted = false,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  bool get _canEdit => (widget.order['status'] as String) == 'pending';
  bool get _isRejected =>
    widget.order['rejected'] == true &&
    (widget.order['status'] as String) == 'pending';
  bool get _showTracking {
    final s = widget.order['status'] as String;
    return s == 'processed' || s == 'completed';
  }

  double get _total {
    final b = (widget.order['base_rate'] as num).toDouble()
      * (widget.order['quantity'] as num).toDouble();
    return b + b * ((widget.order['gst'] as num) / 100)
             + b * ((widget.order['tcs'] as num) / 100);
  }

  String get _totalStr {
    if (_total >= 10000000) {
      return '₹${(_total / 10000000).toStringAsFixed(2)} Cr';
    }
    if (_total >= 100000) {
      return '₹${(_total / 100000).toStringAsFixed(2)} L';
    }
    return '₹${_total.toStringAsFixed(0)}';
  }

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400));
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
    if (widget.isHighlighted) {
      _glowCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_OrderCard old) {
    super.didUpdateWidget(old);
    if (widget.isHighlighted && !old.isHighlighted) {
      _glowCtrl.repeat(reverse: true);
    } else if (!widget.isHighlighted && old.isHighlighted) {
      _glowCtrl.stop(); _glowCtrl.reset();
    }
  }

  @override
  void dispose() { _glowCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = _isRejected
      ? AppColors.error.withValues(alpha: 0.5)
      : widget.isHighlighted
        ? AppColors.primary
        : theme.dividerColor;

    final bgColor = _isRejected
      ? AppColors.error.withValues(alpha: isDark ? 0.06 : 0.04)
      : widget.isHighlighted
        ? AppColors.primary.withValues(alpha: isDark ? 0.1 : 0.06)
        : theme.cardColor;

    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: widget.isHighlighted
            ? [BoxShadow(
                color: AppColors.primary.withValues(
                  alpha: 0.1 + _glowAnim.value * 0.18),
                blurRadius: 10 + _glowAnim.value * 8,
                spreadRadius: _glowAnim.value * 1.5,
              )]
            : null,
        ),
        child: child,
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            width: widget.isHighlighted ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges — Wrap to prevent overflow
                    Wrap(spacing: 6, runSpacing: 4, children: [
                      Text(widget.order['id'] as String,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primary)),
                      StatusBadge.fromString(
                        widget.order['status'] as String),
                      if (_isRejected)
                        _SmallBadge(
                          icon: Icons.error_outline_rounded,
                          label: 'Rejected',
                          color: AppColors.error),
                      if (widget.isHighlighted)
                        _SmallBadge(
                          icon: Icons.my_location_rounded,
                          label: 'Highlighted',
                          color: AppColors.primary),
                    ]),
                    const SizedBox(height: 8),
                    Text(widget.order['buyer_name'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(
                      '${widget.order['quantity']} MT  ·  '
                      '${widget.order['product_type']}  ·  '
                      '${widget.order['port_name']}',
                      style: theme.textTheme.bodySmall),
                    const SizedBox(height: 7),
                    Row(children: [
                      Text(_totalStr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      Text(widget.order['date'] as String,
                        style: theme.textTheme.bodySmall),
                    ]),
                  ],
                )),
                const SizedBox(width: 8),
                Column(children: [
                  _ABtn(icon: Icons.info_outline_rounded,
                    onTap: () => _showDetail(context)),
                  const SizedBox(height: 8),
                  if (_showTracking)
                    _ABtn(
                      icon: Icons.local_shipping_outlined,
                      color: AppColors.primary,
                      onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                          OrderTrackingScreen(
                            order: widget.order,
                            isAdmin: widget.isAdmin))))
                  else
                    _ABtn(
                      icon: Icons.edit_outlined,
                      color: _canEdit ? AppColors.primary
                        : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
                      onTap: _canEdit
                        ? () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                              CreateOrderScreen(
                                prefill: widget.order,
                                isAdmin: widget.isAdmin)))
                        : null),
                ]),
              ],
            ),

            if (_isRejected && widget.order['admin_comment'] != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(
                    alpha: isDark ? 0.08 : 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.25)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.admin_panel_settings_outlined,
                      size: 14, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Comment',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600)),
                        const SizedBox(height: 3),
                        Text(widget.order['admin_comment'] as String,
                          style: theme.textTheme.bodySmall),
                      ],
                    )),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final theme  = Theme.of(context);
    final b = (widget.order['base_rate'] as num).toDouble()
      * (widget.order['quantity'] as num).toDouble();
    final gstAmt = b * ((widget.order['gst'] as num) / 100);
    final tcsAmt = b * ((widget.order['tcs'] as num) / 100);
    final total  = b + gstAmt + tcsAmt;
    String fmt(double v) {
      if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
      if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
      return '₹${v.toStringAsFixed(2)}';
    }

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2)),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Detail', style: AppTextStyles.heading2),
                    const SizedBox(height: 8),
                    Wrap(spacing: 6, runSpacing: 4, children: [
                      StatusBadge.fromString(
                        widget.order['status'] as String),
                      if (_isRejected)
                        _SmallBadge(
                          icon: Icons.error_outline_rounded,
                          label: 'Rejected', color: AppColors.error),
                    ]),
                  ],
                )),
                const SizedBox(width: 8),
                Wrap(spacing: 8, children: [
                  if (_showTracking)
                    OutlinedButton.icon(
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
                            order: widget.order,
                            isAdmin: widget.isAdmin)));
                      },
                    ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.receipt_long_rounded, size: 15),
                    label: const Text('Invoice'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8)),
                    onPressed: () {},
                  ),
                ]),
              ],
            ),

            if (_isRejected && widget.order['admin_comment'] != null) ...[
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
                        Text(widget.order['admin_comment'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 13)),
                      ],
                    )),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            _DSection('Order Info', [
              ('Order ID',     widget.order['id'] as String),
              ('Date',         widget.order['date'] as String),
              ('Sales Person', widget.order['sales_person_name'] as String),
            ]),
            const SizedBox(height: 16),
            _DSection('Product Details', [
              ('Product',      widget.order['product_type'] as String),
              ('Quality',      widget.order['quality'] as String),
              ('Type of Sale', widget.order['type_of_sale'] as String),
              ('Port',         widget.order['port_name'] as String),
              ('Quantity',     '${widget.order['quantity']} MT'),
            ]),
            const SizedBox(height: 16),
            _DSection('Pricing', [
              ('Base Rate', '₹${widget.order['base_rate']}/MT'),
              ('GST', '${widget.order['gst']}%  →  ${fmt(gstAmt)}'),
              ('TCS', '${widget.order['tcs']}%  →  ${fmt(tcsAmt)}'),
              ('Total', fmt(total)),
            ]),
            const SizedBox(height: 16),
            _DSection('Buyer Info', [
              ('Buyer',         widget.order['buyer_name'] as String),
              ('Payment Terms', widget.order['payment_terms'] as String),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Small badge ───────────────────────────────────────────────────────────────
class _SmallBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _SmallBadge({
    required this.icon, required this.label, required this.color});

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

// ── Detail section ────────────────────────────────────────────────────────────
class _DSection extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;
  const _DSection(this.title, this.rows);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: AppTextStyles.label.copyWith(
        letterSpacing: 0.8,
        color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary)),
      const SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          children: rows.asMap().entries.map((e) => Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 11),
              child: Row(children: [
                SizedBox(width: 110,
                  child: Text(e.value.$1,
                    style: theme.textTheme.bodySmall)),
                Expanded(child: Text(e.value.$2,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500))),
              ]),
            ),
            if (e.key < rows.length - 1)
              Divider(height: 1, indent: 14, endIndent: 14,
                color: theme.dividerColor),
          ])).toList(),
        ),
      ),
    ]);
  }
}

// ── Action button ─────────────────────────────────────────────────────────────
class _ABtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  const _ABtn({required this.icon, this.onTap,
    this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: onTap == null
              ? Colors.transparent : theme.dividerColor),
        ),
        child: Icon(icon, size: 17,
          color: onTap == null
            ? (theme.brightness == Brightness.dark
                ? AppColors.textMuted : AppColors.lightTextMuted)
            : color),
      ),
    );
  }
}
