import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';
import '../../../data/order_store.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/shcc_bottom_nav.dart';

import '../../search/screens/search_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../notifications/notifications_screen.dart';
import 'port_admin_order_detail_screen.dart';
import 'stock_management_screen.dart';

class PortAdminDashboardScreen extends StatefulWidget {
  const PortAdminDashboardScreen({super.key});
  @override
  State<PortAdminDashboardScreen> createState() =>
      _PortAdminDashboardScreenState();
}

class _PortAdminDashboardScreenState extends State<PortAdminDashboardScreen> {
  int _navIndex = 0;
  late final PageController _pageCtrl;
  String? _highlightOrder;

  List<Map<String, dynamic>> get _myOrders =>
      OrderStore.getOrdersForPorts(AppSession.instance.assignedPorts);

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
      case NotifType.targetModified:
      case NotifType.targetCompleted:
      case NotifType.catalogueUpdated:
      case NotifType.portAssignment:
        setState(() {
          _highlightOrder = null;
          _navIndex = 3;
        });
        _pageCtrl.animateToPage(3,
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;
    final pages = [
      _PortAdminHome(
        orders: _myOrders,
        onRefresh: () => setState(() {}),
        onNotifNav: _onNotifNav,
        onOrderTap: (order) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PortAdminOrderDetailScreen(order: order),
          ),
        ).then((_) => setState(() {})),
      ),
      SearchScreen(
        isPortAdmin: true,
        assignedPorts: session.assignedPorts,
        highlightOrderId: _highlightOrder,
      ),
      const StockManagementScreen(),
      ProfileScreen(
        isPortAdmin: true,
        fromTab: true,
        onGoHome: () => _goTo(0),
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageCtrl,
        physics: const _SwipePhysics(),
        onPageChanged: (page) => setState(() => _navIndex = page),
        children: pages,
      ),
      bottomNavigationBar: ShccBottomNav(
        currentIndex: _navIndex,
        isPortAdmin: true,
        onTap: _goTo,
      ),
    );
  }
}

class _SwipePhysics extends PageScrollPhysics {
  const _SwipePhysics() : super(parent: const ClampingScrollPhysics());
  @override
  _SwipePhysics applyTo(ScrollPhysics? ancestor) => const _SwipePhysics();
}

// ── _PortAdminHome ────────────────────────────────────────────────────────────
class _PortAdminHome extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final VoidCallback onRefresh;
  final NotifNavCallback onNotifNav;
  final void Function(Map<String, dynamic>) onOrderTap;

  const _PortAdminHome({
    required this.orders,
    required this.onRefresh,
    required this.onNotifNav,
    required this.onOrderTap,
  });

  /// Orders that Port Admin must act on — excludes pending/rejected/completed.
  List<Map<String, dynamic>> get _actionable {
    const actionableStatuses = {
      AppConstants.statusApproved,
      AppConstants.statusOnHold,
      AppConstants.statusDispatched,
    };
    final filtered =
        orders.where((o) => actionableStatuses.contains(o['status'])).toList();

    // Priority: approved → on_hold → dispatched
    const priority = {
      AppConstants.statusApproved: 0,
      AppConstants.statusOnHold: 1,
      AppConstants.statusDispatched: 2,
    };
    filtered.sort((a, b) =>
        (priority[a['status']] ?? 99).compareTo(priority[b['status']] ?? 99));
    return filtered;
  }

  int _count(String status) =>
      _actionable.where((o) => o['status'] == status).length;

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;
    final actionable = _actionable;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        userInitials: session.initials,
        actions: [
          NotificationBell(
            person: session.name,
            role: session.role,
            onNavigate: onNotifNav,
          ),
          const SizedBox(width: 4),
        ],
        onProfileTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(isPortAdmin: true, fromTab: false),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Port Overview', style: AppTextStyles.heading1),
                    const SizedBox(height: 4),
                    Text(
                      session.assignedPorts.join('  ·  '),
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── KPI Row ─────────────────────────────────────────────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _KpiTile(
                    label: 'Awaiting\nDispatch',
                    value: '${_count(AppConstants.statusApproved)}',
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.info,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _KpiTile(
                    label: 'On Hold',
                    value: '${_count(AppConstants.statusOnHold)}',
                    icon: Icons.pause_circle_outline_rounded,
                    color: AppColors.warning,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _KpiTile(
                    label: 'In Transit',
                    value: '${_count(AppConstants.statusDispatched)}',
                    icon: Icons.flight_takeoff_rounded,
                    color: const Color(0xFF14B8A6),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Actionable Orders ────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text('Actionable Orders', style: AppTextStyles.heading3),
              ),
              if (actionable.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${actionable.length} order${actionable.length == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          if (actionable.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.check_circle_outline_rounded,
                      color: AppColors.success, size: 40),
                  const SizedBox(height: 12),
                  Text('All clear!', style: AppTextStyles.heading3),
                  const SizedBox(height: 6),
                  Text(
                    'No orders awaiting action for your assigned ports.',
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...actionable.map(
              (o) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ActionableCard(order: o, onTap: () => onOrderTap(o)),
              ),
            ),
        ],
      ),
    );
  }
}

// ── KPI tile ─────────────────────────────────────────────────────────────────
class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.10 : 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.85),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Actionable order card ────────────────────────────────────────────────────
class _ActionableCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const _ActionableCard({required this.order, required this.onTap});

  Color _statusColor(String status) {
    switch (status) {
      case AppConstants.statusApproved:
        return AppColors.info;
      case AppConstants.statusOnHold:
        return AppColors.warning;
      case AppConstants.statusDispatched:
        return const Color(0xFF14B8A6);
      default:
        return AppColors.textMuted;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case AppConstants.statusApproved:
        return 'Awaiting Dispatch';
      case AppConstants.statusOnHold:
        return 'On Hold';
      case AppConstants.statusDispatched:
        return 'In Transit';
      default:
        return status;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case AppConstants.statusApproved:
        return Icons.local_shipping_outlined;
      case AppConstants.statusOnHold:
        return Icons.pause_circle_outline_rounded;
      case AppConstants.statusDispatched:
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? '';
    final sColor = _statusColor(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status bar at top
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: sColor.withValues(alpha: isDark ? 0.12 : 0.08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: sColor.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(_statusIcon(status), color: sColor, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    _statusLabel(status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: sColor,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order['id'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['buyer_name'] as String? ?? '',
                              style: AppTextStyles.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              order['sales_person_name'] as String? ?? '',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted, size: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.anchor_rounded,
                        label: order['port_name'] as String? ?? '',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.scale_rounded,
                        label: '${order['quantity']} MT',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.local_fire_department_rounded,
                        label: order['product_type'] as String? ?? '',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small inline meta chip ───────────────────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
