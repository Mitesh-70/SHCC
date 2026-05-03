import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/shcc_bottom_nav.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../dashboard/widgets/kpi_card.dart';
import '../../catalogue/screens/catalogue_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../orders/screens/create_order_screen.dart';

// ── Shared target store (simple in-memory — replace with provider/db) ─────────
class TargetStore {
  static final Map<String, double> targets = {
    'Raj Sharma':  5000000,
    'Amit Patel':  4000000,
    'Priya Mehta': 3500000,
  };
  static final Map<String, double> achieved = {
    'Raj Sharma':  3100000,
    'Amit Patel':  2800000,
    'Priya Mehta': 1900000,
  };
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _navIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const _AdminHome(),
      const SearchScreen(isAdmin: true),
      const ReportsScreen(),
      const CatalogueScreen(isAdmin: true),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _navIndex, children: _pages),
      bottomNavigationBar: ShccBottomNav(
        currentIndex: _navIndex, isAdmin: true,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _AdminHome extends StatefulWidget {
  const _AdminHome();
  @override
  State<_AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<_AdminHome> {
  bool    _processing  = false;
  String? _processingId;

  final List<Map<String, dynamic>> _pending = [
    {
      'id': 'ORD-2024-049', 'salesman': 'Raj Sharma', 'buyer_name': 'Birla Cement',
      'product_type': 'Indonesian Coal', 'base_rate': 7100.0,
      'gst': 18.0, 'tcs': 0.1, 'quantity': 300.0,
      'type_of_sale': 'F.O.R.', 'quality': '4000 GAR',
      'port_name': 'Mundra', 'payment_terms': 'Advance', 'time': '10 min ago',
    },
    {
      'id': 'ORD-2024-050', 'salesman': 'Amit Patel', 'buyer_name': 'Essar Steel',
      'product_type': 'South African Coal', 'base_rate': 6200.0,
      'gst': 18.0, 'tcs': 0.1, 'quantity': 450.0,
      'type_of_sale': 'Spot', 'quality': '5000 GAR',
      'port_name': 'Hazira', 'payment_terms': 'LC', 'time': '25 min ago',
    },
    {
      'id': 'ORD-2024-051', 'salesman': 'Priya Mehta', 'buyer_name': 'ACC Cement',
      'product_type': 'Russian Coal', 'base_rate': 4800.0,
      'gst': 18.0, 'tcs': 0.1, 'quantity': 200.0,
      'type_of_sale': 'Spot', 'quality': '4200 GAR',
      'port_name': 'Kandla', 'payment_terms': 'On Delivery', 'time': '1 hr ago',
    },
  ];

  Future<void> _act(int index, bool approve) async {
    final id = _pending[index]['id'] as String;
    setState(() { _processing = true; _processingId = id; });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _processing = false; _processingId = null; _pending.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(approve ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: approve ? AppColors.success : AppColors.error, size: 18),
        const SizedBox(width: 10),
        Text('Order ${approve ? 'approved & confirmed' : 'rejected'}',
          style: AppTextStyles.body),
      ]),
      backgroundColor: AppColors.bgCard,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: ShccAppBar(
          logoAsset: 'assets/images/logo.png',
          userInitials: 'AD',
          onProfileTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ProfileScreen())),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_rounded,
                  color: AppColors.primary, size: 20),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const CreateOrderScreen(isAdmin: true))),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            Text('Admin Panel', style: AppTextStyles.bodySecondary),
            const SizedBox(height: 2),
            const Text('Overview', style: AppTextStyles.heading1),
            const SizedBox(height: 24),

            GridView.count(
              crossAxisCount: 2, shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
              children: [
                const KpiCard(label: 'Total Orders', value: '142',
                  icon: Icons.receipt_long_rounded, color: AppColors.primary),
                const KpiCard(label: 'Revenue MTD', value: '₹3.2 Cr',
                  icon: Icons.currency_rupee_rounded, color: AppColors.success),
                KpiCard(label: 'Awaiting Approval', value: '${_pending.length}',
                  icon: Icons.pending_actions_rounded, color: AppColors.warning),
                const KpiCard(label: 'Active Salesmen', value: '8',
                  icon: Icons.people_rounded, color: AppColors.info),
              ],
            ),
            const SizedBox(height: 24),

            // ── Create order banner ───────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.04),
                  ],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_shopping_cart_rounded,
                    color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create New Order', style: AppTextStyles.bodyMedium),
                    Text('Admin order entry', style: AppTextStyles.caption),
                  ],
                )),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10)),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const CreateOrderScreen(isAdmin: true))),
                  child: const Text('Create'),
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Sales Target Management ───────────────────────────
            const _SalesTargetCard(),
            const SizedBox(height: 24),

            SectionHeader(
              title: 'Pending Approvals',
              actionLabel: _pending.isEmpty ? null : '${_pending.length} new',
            ),
            const SizedBox(height: 14),

            if (_pending.isEmpty)
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(children: [
                  const Icon(Icons.check_circle_outline_rounded,
                    color: AppColors.success, size: 36),
                  const SizedBox(height: 12),
                  Text('All caught up!', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text('No pending orders to review.',
                    style: AppTextStyles.bodySecondary),
                ]),
              )
            else
              ...List.generate(_pending.length, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _ApprovalCard(
                  order: _pending[i],
                  isProcessing: _processingId == _pending[i]['id'],
                  onApprove: () => _act(i, true),
                  onReject:  () => _act(i, false),
                ),
              )),
          ],
        ),
      ),
      if (_processing) const LoadingOverlay(message: 'Processing…'),
    ]);
  }
}

// ── Sales Target Card ─────────────────────────────────────────────────────────
class _SalesTargetCard extends StatefulWidget {
  const _SalesTargetCard();
  @override
  State<_SalesTargetCard> createState() => _SalesTargetCardState();
}

class _SalesTargetCardState extends State<_SalesTargetCard> {
  final _salesPersons = ['Raj Sharma', 'Amit Patel', 'Priya Mehta'];
  String? _selected;
  final _targetCtrl = TextEditingController();
  bool _saved = false;

  @override
  void dispose() { _targetCtrl.dispose(); super.dispose(); }

  void _save() {
    final v = double.tryParse(_targetCtrl.text);
    if (_selected == null || v == null || v <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select a salesperson and enter a valid target'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    setState(() {
      TargetStore.targets[_selected!] = v;
      _saved = true;
    });
    Future.delayed(const Duration(seconds: 2),
      () { if (mounted) setState(() => _saved = false); });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text('Target updated for $_selected',
          style: AppTextStyles.body),
      ]),
      backgroundColor: AppColors.bgCard,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  String _fmt(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.infoMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.track_changes_rounded,
              size: 15, color: AppColors.info),
          ),
          const SizedBox(width: 10),
          Text('Sales Targets', style: AppTextStyles.heading3),
        ]),
        const SizedBox(height: 16),

        // Current targets overview
        ...TargetStore.targets.entries.map((e) {
          final achieved = TargetStore.achieved[e.key] ?? 0;
          final pct = e.value == 0 ? 0.0 : (achieved / e.value).clamp(0.0, 1.0);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(e.key, style: AppTextStyles.bodyMedium),
                Text('${(pct * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: pct >= 1 ? AppColors.success : AppColors.primary)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Expanded(child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct, minHeight: 6,
                    backgroundColor: AppColors.bgBase,
                    valueColor: AlwaysStoppedAnimation(
                      pct >= 1 ? AppColors.success : AppColors.primary),
                  ),
                )),
                const SizedBox(width: 8),
                Text('${_fmt(achieved)} / ${_fmt(e.value)}',
                  style: AppTextStyles.caption),
              ]),
            ]),
          );
        }),
        const Divider(color: AppColors.border, height: 24),

        // Assign/update target
        Text('Assign / Update Target',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary, letterSpacing: 0.6)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selected,
          dropdownColor: AppColors.bgCard,
          style: AppTextStyles.body,
          hint: Text('Select sales person', style: AppTextStyles.caption),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
            color: AppColors.textMuted),
          decoration: const InputDecoration(
            labelText: 'Sales Person',
            prefixIcon: Icon(Icons.person_outline_rounded,
              size: 18, color: AppColors.textMuted),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 12),
          ),
          items: _salesPersons.map((p) => DropdownMenuItem(
            value: p,
            child: Text(p, style: AppTextStyles.body),
          )).toList(),
          onChanged: (v) => setState(() {
            _selected = v;
            if (v != null && TargetStore.targets.containsKey(v)) {
              _targetCtrl.text =
                TargetStore.targets[v]!.toStringAsFixed(0);
            } else {
              _targetCtrl.clear();
            }
          }),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _targetCtrl,
          style: AppTextStyles.body,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Monthly Target (₹)',
            prefixIcon: Icon(Icons.currency_rupee_rounded,
              size: 18, color: AppColors.textMuted),
            prefixText: '₹ ',
            prefixStyle: TextStyle(
              color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(_saved
              ? Icons.check_rounded : Icons.save_rounded, size: 16),
            label: Text(_saved ? 'Saved!' : 'Save Target'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _saved ? AppColors.success : AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _save,
          ),
        ),
      ]),
    );
  }
}

// ── Approval card ─────────────────────────────────────────────────────────────
class _ApprovalCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final bool isProcessing;
  final VoidCallback onApprove, onReject;
  const _ApprovalCard({
    required this.order, required this.isProcessing,
    required this.onApprove, required this.onReject,
  });
  @override
  State<_ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<_ApprovalCard> {
  final _commentCtrl = TextEditingController();
  bool _showComment  = false;

  double get _total {
    final b = (widget.order['base_rate'] as num).toDouble()
      * (widget.order['quantity'] as num).toDouble();
    return b + b * ((widget.order['gst'] as num) / 100)
             + b * ((widget.order['tcs'] as num) / 100);
  }

  String get _totalStr {
    final v = _total;
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryMuted, shape: BoxShape.circle),
            child: Center(child: Text(
              (o['salesman'] as String).substring(0, 1),
              style: const TextStyle(color: AppColors.primary,
                fontWeight: FontWeight.w700, fontSize: 15))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(o['salesman'] as String, style: AppTextStyles.bodyMedium),
              Text(o['time'] as String, style: AppTextStyles.caption),
            ],
          )),
          Text(o['id'] as String,
            style: AppTextStyles.label.copyWith(color: AppColors.primary)),
        ]),
        const SizedBox(height: 12),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 12),
        Text(o['buyer_name'] as String, style: AppTextStyles.heading3),
        const SizedBox(height: 4),
        Text('${o['product_type']}  ·  ${o['quality']}  ·  ${o['quantity']} MT',
          style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text('${o['type_of_sale']}  ·  ${o['port_name']}  ·  ${o['payment_terms']}',
          style: AppTextStyles.caption),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryMuted,
            borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: AppTextStyles.caption),
              Text(_totalStr, style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w700)),
            ]),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _showComment
            ? Padding(
                key: const ValueKey('comment'),
                padding: const EdgeInsets.only(top: 12),
                child: TextField(
                  controller: _commentCtrl,
                  style: AppTextStyles.body, maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Add a note before rejecting…',
                    labelText: 'Comment (optional)'),
                ),
              )
            : const SizedBox(key: ValueKey('none')),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('Reject'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: widget.isProcessing ? null : () {
              if (!_showComment) {
                setState(() => _showComment = true); return;
              }
              widget.onReject();
            },
          )),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(
            icon: const Icon(Icons.check_rounded, size: 16),
            label: const Text('Approve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: widget.isProcessing ? null : widget.onApprove,
          )),
        ]),
      ]),
    );
  }
}
