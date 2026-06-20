import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';
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
import '../../notifications/notifications_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/order_store.dart';
import 'port_admin_management_screen.dart';

// ── Shared target store ───────────────────────────────────────────────────────
class TargetStore {
  static final Map<String, double> targets = {
    'Raj Sharma': 5000000,
    'Amit Patel': 4000000,
    'Priya Mehta': 3500000,
  };
  static final Map<String, double> achieved = {
    'Raj Sharma': 3100000,
    'Amit Patel': 2800000,
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
  late final PageController _pageCtrl;
  String? _highlightOrder;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _goTo(int navIndex) {
    setState(() => _navIndex = navIndex);
    _pageCtrl.animateToPage(
      navIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _onNotifNav(NotifType type, {String? orderId}) {
    switch (type) {
      case NotifType.orderApproved:
      case NotifType.orderAccepted:
      case NotifType.orderRejected:
      case NotifType.orderCreated:
      case NotifType.dispatchUpdated:
      case NotifType.orderOnHold:
      case NotifType.holdReleased:
        setState(() {
          _highlightOrder = orderId;
          _navIndex = 1;
        });
        _pageCtrl.animateToPage(1,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut);
        break;
      case NotifType.catalogueUpdated:
        setState(() {
          _highlightOrder = null;
          _navIndex = 3;
        });
        _pageCtrl.animateToPage(3,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut);
        break;
      case NotifType.targetModified:
      case NotifType.targetCompleted:
        setState(() {
          _highlightOrder = null;
          _navIndex = 4;
        });
        _pageCtrl.animateToPage(4,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pages are built here (not in initState) so that _goTo can be
    // passed as the onGoHome callback to ProfileScreen.
    final pages = [
      _AdminHome(onNotifNav: _onNotifNav),
      SearchScreen(isAdmin: true, highlightOrderId: _highlightOrder),
      const ReportsScreen(),
      const CatalogueScreen(isAdmin: true),
      ProfileScreen(isAdmin: true, fromTab: true, onGoHome: () => _goTo(0)),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageCtrl,
        physics: const _SwipePhysics(),
        onPageChanged: (page) {
          setState(() => _navIndex = page);
        },
        children: pages,
      ),
      bottomNavigationBar: ShccBottomNav(
        currentIndex: _navIndex,
        isAdmin: true,
        onTap: _goTo,
      ),
    );
  }
}

// ── Custom physics: swipe only when not inside a scrollable ──────────────────
class _SwipePhysics extends PageScrollPhysics {
  const _SwipePhysics() : super(parent: const ClampingScrollPhysics());

  @override
  _SwipePhysics applyTo(ScrollPhysics? ancestor) => const _SwipePhysics();
}

class _AdminHome extends StatefulWidget {
  final NotifNavCallback onNotifNav;
  const _AdminHome({required this.onNotifNav});
  @override
  State<_AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<_AdminHome> {
  bool _processing = false;
  String? _processingId;

  List<Map<String, dynamic>> get _pending => OrderStore.getPendingApproval();

  void _notifyPortAdminsForOrder(
    Map<String, dynamic> order,
    String title,
    String description,
    NotifType type,
  ) {
    final port = order['port_name'] as String;
    for (final pa in PortAdminStore.users) {
      if (pa.isActive && pa.assignedPorts.contains(port)) {
        NotificationStore.add(
          person: pa.name,
          title: title,
          description: description,
          type: type,
          orderId: order['id'] as String,
        );
      }
    }
  }

  Future<void> _act(Map<String, dynamic> order, bool approve, {String? comment}) async {
    final id = order['id'] as String;
    final salesman = order['sales_person_name'] as String? ??
        order['salesman'] as String? ??
        'Raj Sharma';
    setState(() {
      _processing = true;
      _processingId = id;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    if (approve) {
      OrderStore.updateOrderStatus(id, AppConstants.statusApproved);
      NotificationStore.add(
        person: salesman,
        title: 'Order Approved',
        description: 'Your order $id has been approved by Admin.',
        type: NotifType.orderApproved,
        orderId: id,
      );
      _notifyPortAdminsForOrder(
        OrderStore.getOrderById(id) ?? order,
        'New Approved Order',
        'Order $id for ${order['port_name']} is ready for dispatch.',
        NotifType.orderApproved,
      );
    } else {
      OrderStore.updateOrderStatus(
        id,
        AppConstants.statusRejected,
        comment: comment,
      );
      NotificationStore.add(
        person: salesman,
        title: 'Order Rejected',
        description:
            'Your order $id was rejected.${comment != null && comment.isNotEmpty ? ' Comment: $comment' : ''}',
        type: NotifType.orderRejected,
        orderId: id,
      );
      _notifyPortAdminsForOrder(
        order,
        'Order Rejected',
        'Order $id was rejected by Admin.',
        NotifType.orderRejected,
      );
    }

    setState(() {
      _processing = false;
      _processingId = null;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              approve ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: approve ? AppColors.success : AppColors.error,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'Order ${approve ? 'approved' : 'rejected'}',
              style: AppTextStyles.body,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).cardColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: ShccAppBar(
            logoAsset: 'assets/images/logo.png',
            userInitials: AppSession.isLoggedIn ? AppSession.instance.initials : 'AD',
            actions: [
              NotificationBell(
                person: AppSession.isLoggedIn ? AppSession.instance.name : 'Admin',
                role: AppSession.isLoggedIn ? AppSession.instance.role : 'admin',
                onNavigate: widget.onNotifNav,
              ),
              const SizedBox(width: 4),
            ],
            onProfileTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const ProfileScreen(isAdmin: true, fromTab: false),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            children: [
              Text('Overview', style: AppTextStyles.heading1),
              const SizedBox(height: 24),

              Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: const [
                        Expanded(
                          child: KpiCard(
                            label: 'Total Orders',
                            value: '149',
                            icon: Icons.receipt_long_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: KpiCard(
                            label: 'Revenue MTD',
                            value: '3.2 Cr',
                            icon: Icons.currency_rupee_rounded,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: KpiCard(
                            label: 'Awaiting Approval',
                            value: '${_pending.length}',
                            icon: Icons.pending_actions_rounded,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: KpiCard(
                            label: 'Active Salesmen',
                            value: '8',
                            icon: Icons.people_rounded,
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Manage Port Admins quick link
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PortAdminManagementScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.anchor_rounded,
                            color: AppColors.info),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Manage Port Admins',
                                style: AppTextStyles.bodyMedium),
                            Text('Assign ports & manage users',
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Create order banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 44), // Empty spacer to perfectly center the text
                    Expanded(
                      child: Text(
                        'Create New Order',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateOrderScreen(isAdmin: true),
                        ),
                      ),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text('All caught up!', style: AppTextStyles.heading3),
                      const SizedBox(height: 4),
                      Text(
                        'No pending orders to review.',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ],
                  ),
                )
              else
                ...List.generate(
                  _pending.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ApprovalCard(
                      order: {
                        ..._pending[i],
                        'salesman': _pending[i]['sales_person_name'] ??
                            _pending[i]['salesman'] ??
                            'Unknown',
                      },
                      isProcessing: _processingId == _pending[i]['id'],
                      onApprove: () => _act(_pending[i], true),
                      onReject: (comment) =>
                          _act(_pending[i], false, comment: comment),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_processing) const LoadingOverlay(message: 'Processing…'),
      ],
    );
  }
}

class _ApprovalCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final bool isProcessing;
  final VoidCallback onApprove;
  final void Function(String?) onReject;

  const _ApprovalCard({
    required this.order,
    required this.isProcessing,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends State<_ApprovalCard> {
  final _commentCtrl = TextEditingController();
  bool _showComment = false;

  double get _total {
    final b =
        (widget.order['base_rate'] as num).toDouble() *
        (widget.order['quantity'] as num).toDouble();
    final f = ((widget.order['freight'] ?? 0.0) as num).toDouble();
    return b +
        f +
        b * ((widget.order['gst'] as num) / 100) +
        b * ((widget.order['tcs'] as num) / 100);
  }

  String get _totalStr {
    final v = _total;
    if (v >= 10000000) {
      return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    }
    if (v >= 100000) {
      return '₹${(v / 100000).toStringAsFixed(2)} L';
    }
    return '₹${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (o['salesman'] as String).substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o['salesman'] as String,
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      o['time'] as String? ?? o['date'] as String? ?? '',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              Text(
                o['id'] as String,
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Text(o['buyer_name'] as String, style: AppTextStyles.heading3),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          o['product_type'] as String,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grade_outlined,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          o['quality'] as String,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.scale_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${o['quantity']} MT',
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          o['type_of_sale'] as String,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.anchor_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          o['port_name'] as String,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.payment_rounded,
                        size: 15,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          o['payment_terms'] as String,
                          style: AppTextStyles.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Freight', style: AppTextStyles.caption),
                    Text(
                      '₹${((widget.order['freight'] ?? 0.0) as num).toDouble().toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Amount', style: AppTextStyles.caption),
                    Text(
                      _totalStr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _showComment
                ? Padding(
                    key: const ValueKey('comment'),
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: _commentCtrl,
                      style: AppTextStyles.body,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Add a note (will be shown to salesperson)…',
                        labelText: 'Rejection Comment',
                      ),
                    ),
                  )
                : const SizedBox(key: ValueKey('none')),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.close_rounded, size: 16),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: widget.isProcessing
                      ? null
                      : () {
                          if (!_showComment) {
                            setState(() => _showComment = true);
                            return;
                          }
                          widget.onReject(_commentCtrl.text.trim());
                        },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: widget.isProcessing ? null : widget.onApprove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}