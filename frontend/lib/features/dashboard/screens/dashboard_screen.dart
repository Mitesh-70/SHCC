import 'package:flutter/material.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/shcc_bottom_nav.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../widgets/kpi_card.dart';
import '../widgets/recent_order_tile.dart';
import '../../orders/screens/create_order_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../catalogue/screens/catalogue_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../notifications/notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int     _navIndex       = 0;
  String? _highlightOrder;
  late final PageController _pageCtrl;

  // Tab 2 (Order) opens a modal — not a swipeable page
  // Swipeable tabs: 0 Home, 1 Search, 2 Catalogue, 3 Profile
  // We map nav indices [0,1,3,4] to page indices [0,1,2,3]
  // Tab 2 (Order) is excluded from swipe — tapping opens modal

  static const _swipeTabCount = 4;

  int _navToPage(int nav) {
    if (nav == 0) return 0;
    if (nav == 1) return 1;
    if (nav == 3) return 2;
    if (nav == 4) return 3;
    return 0;
  }

  int _pageToNav(int page) {
    if (page == 0) return 0;
    if (page == 1) return 1;
    if (page == 2) return 3;
    if (page == 3) return 4;
    return 0;
  }

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
    if (navIndex == 2) {
      // Order tab — open as full screen push, don't switch page
      Navigator.push(context,
        MaterialPageRoute(builder: (_) => const CreateOrderScreen()));
      return;
    }
    final page = _navToPage(navIndex);
    setState(() => _navIndex = navIndex);
    _pageCtrl.animateToPage(page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut);
  }

  void _onNotifNav(NotifType type, {String? orderId}) {
    switch (type) {
      case NotifType.orderAccepted:
      case NotifType.orderRejected:
        setState(() { _highlightOrder = orderId; _navIndex = 1; });
        _pageCtrl.animateToPage(1,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut);
        break;
      case NotifType.catalogueUpdated:
        setState(() { _highlightOrder = null; _navIndex = 3; });
        _pageCtrl.animateToPage(2,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut);
        break;
      case NotifType.targetModified:
      case NotifType.targetCompleted:
        setState(() { _highlightOrder = null; _navIndex = 4; });
        _pageCtrl.animateToPage(3,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageCtrl,
        // Only allow swipe on non-scroll-heavy pages
        physics: const _SwipePhysics(),
        onPageChanged: (page) {
          setState(() => _navIndex = _pageToNav(page));
        },
        children: [
          _SalesHome(onNavTap: _goTo, onNotifNav: _onNotifNav),
          SearchScreen(
            isAdmin: false,
            highlightOrderId: _highlightOrder,
          ),
          const CatalogueScreen(isAdmin: false),
          ProfileScreen(
            isAdmin: false,
            fromTab: true,
            onGoHome: () => _goTo(0),
          ),
        ],
      ),
      bottomNavigationBar: ShccBottomNav(
        currentIndex: _navIndex,
        onTap: _goTo,
      ),
    );
  }
}

// ── Custom physics: swipe only when not inside a scrollable ──────────────────
class _SwipePhysics extends PageScrollPhysics {
  const _SwipePhysics() : super(parent: const ClampingScrollPhysics());

  @override
  _SwipePhysics applyTo(ScrollPhysics? ancestor) =>
    const _SwipePhysics();
}

// ── Sales home ────────────────────────────────────────────────────────────────
class _SalesHome extends StatelessWidget {
  final void Function(int) onNavTap;
  final NotifNavCallback onNotifNav;
  const _SalesHome({required this.onNavTap, required this.onNotifNav});

  static const _recentOrders = [
    {
      'id': 'ORD-2024-048', 'buyer_name': 'JSW Steel Ltd',
      'base_rate': 6200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 200.0,
      'type_of_sale': 'Spot', 'product_type': 'Indonesian Coal',
      'port_name': 'Mundra', 'status': 'processed', 'date': '28 Apr',
    },
    {
      'id': 'ORD-2024-047', 'buyer_name': 'Ultratech Cement',
      'base_rate': 6100.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 150.0,
      'type_of_sale': 'F.O.R.', 'product_type': 'South African Coal',
      'port_name': 'Kandla', 'status': 'pending', 'date': '27 Apr',
      'rejected': true,
      'admin_comment': 'Quantity too high. Reduce to 100 MT.',
    },
    {
      'id': 'ORD-2024-046', 'buyer_name': 'Tata Steel',
      'base_rate': 5600.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 500.0,
      'type_of_sale': 'Spot', 'product_type': 'Russian Coal',
      'port_name': 'Hazira', 'status': 'completed', 'date': '26 Apr',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        onProfileTap: () => Navigator.push(context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(
              isAdmin: false,
              fromTab: false,
            ))),
        userInitials: 'RS',
        actions: [
          NotificationBell(
            person: 'Raj Sharma',
            onNavigate: onNotifNav,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          // Welcome
          Text('Good morning,', style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          Text('Raj Sharma',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('Sales Staff  ·  Surat Region',
            style: theme.textTheme.bodySmall),
          const SizedBox(height: 24),

          // KPI grid
          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12,
            childAspectRatio: 2.3,
            children: const [
              KpiCard(label: 'Total Orders', value: '48',
                icon: Icons.receipt_long_rounded,
                color: AppColors.primary),
              KpiCard(label: 'Revenue MTD', value: '84.2L',
                icon: Icons.currency_rupee_rounded,
                color: AppColors.success),
              KpiCard(label: 'Pending', value: '6',
                icon: Icons.hourglass_top_rounded,
                color: AppColors.warning),
              KpiCard(
                label: 'Target Achieved',
                value: '62%',
                icon: Icons.track_changes_rounded,
                color: AppColors.info,
                progressValue: 0.62,
                progressLabel: '₹31L of ₹50L',
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Quick actions
          const SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _QuickAction(
              icon: Icons.add_shopping_cart_rounded,
              label: 'New Order', color: AppColors.primary,
              onTap: () => onNavTap(2),
            )),
            const SizedBox(width: 10),
            Expanded(child: _QuickAction(
              icon: Icons.search_rounded,
              label: 'Search', color: AppColors.info,
              onTap: () => onNavTap(1),
            )),
            const SizedBox(width: 10),
            Expanded(child: _QuickAction(
              icon: Icons.inventory_2_rounded,
              label: 'Catalogue', color: AppColors.success,
              onTap: () => onNavTap(3),
            )),
          ]),
          const SizedBox(height: 28),

          // Recent orders
          SectionHeader(
            title: 'Recent Orders',
            actionLabel: 'View All',
            onAction: () => onNavTap(1),
          ),
          const SizedBox(height: 14),
          ..._recentOrders.map((o) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RecentOrderTile(order: o),
          )),
        ],
      ),
    );
  }
}

// ── Quick action button ───────────────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon, required this.label,
    required this.color, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: color.withValues(alpha: isDark ? 0.1 : 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: color.withValues(alpha: 0.18),
        highlightColor: color.withValues(alpha: 0.1),
        child: Container(
          height: 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isDark ? 0.15 : 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
