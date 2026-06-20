import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';
import '../../../data/order_store.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/shcc_bottom_nav.dart';
import '../../../shared/widgets/section_header.dart';
import '../../dashboard/widgets/kpi_card.dart';
import '../../search/screens/search_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../notifications/notifications_screen.dart';
import 'port_admin_order_detail_screen.dart';

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
        setState(() {
          _highlightOrder = null;
          _navIndex = 2;
        });
        _pageCtrl.animateToPage(2,
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

  int _count(String status) =>
      orders.where((o) => o['status'] == status).length;

  @override
  Widget build(BuildContext context) {
    final session = AppSession.instance;
    final recent = orders.take(5).toList();

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
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Text('Port Overview', style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text(
            '${session.name}  ·  ${session.assignedPorts.join(', ')}',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: KpiCard(
                        label: 'Assigned Orders',
                        value: '${orders.length}',
                        icon: Icons.receipt_long_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KpiCard(
                        label: 'Pending Dispatch',
                        value: '${_count(AppConstants.statusApproved)}',
                        icon: Icons.local_shipping_outlined,
                        color: AppColors.info,
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
                        label: 'On Hold',
                        value: '${_count(AppConstants.statusOnHold)}',
                        icon: Icons.pause_circle_outline_rounded,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: KpiCard(
                        label: 'Dispatched',
                        value: '${_count(AppConstants.statusDispatched)}',
                        icon: Icons.flight_takeoff_rounded,
                        color: const Color(0xFF14B8A6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              KpiCard(
                label: 'Completed',
                value: '${_count(AppConstants.statusCompleted)}',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Recent Activity',
            actionLabel: orders.isEmpty ? null : '${orders.length} total',
          ),
          const SizedBox(height: 14),
          if (recent.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined,
                      color: AppColors.textMuted, size: 36),
                  const SizedBox(height: 12),
                  Text('No orders yet', style: AppTextStyles.heading3),
                  const SizedBox(height: 4),
                  Text('Orders for your assigned ports will appear here.',
                      style: AppTextStyles.bodySecondary),
                ],
              ),
            )
          else
            ...recent.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ActivityCard(order: o, onTap: () => onOrderTap(o)),
                )),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onTap;

  const _ActivityCard({required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order['id'] as String,
                      style: AppTextStyles.label
                          .copyWith(color: AppColors.primary)),
                  const SizedBox(height: 4),
                  Text(order['buyer_name'] as String,
                      style: AppTextStyles.bodyMedium),
                  Text(
                    '${order['port_name']}  ·  ${order['quantity']} MT',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
