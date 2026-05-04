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
  int _navIndex = 0;

  void _goTo(int index) => setState(() => _navIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      _SalesHome(onNavTap: _goTo),
      const SearchScreen(isAdmin: false),
      const CreateOrderScreen(),
      const CatalogueScreen(isAdmin: false),
      const ProfileScreen(isAdmin: false),
    ];

    return Scaffold(
      body: IndexedStack(index: _navIndex, children: pages),
      bottomNavigationBar: ShccBottomNav(
        currentIndex: _navIndex,
        onTap: _goTo,
      ),
    );
  }
}

class _SalesHome extends StatelessWidget {
  final void Function(int) onNavTap;
  const _SalesHome({required this.onNavTap});

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
      'admin_comment': 'Quantity too high for this port. Please reduce to 100 MT.',
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
    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        onProfileTap: () => Navigator.push(
          context, MaterialPageRoute(
            builder: (_) => const ProfileScreen(isAdmin: false))),
        userInitials: 'RS',
        actions: const [
          NotificationBell(person: 'Raj Sharma'),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
        children: [
          Text('Good morning,', style: AppTextStyles.bodySecondary),
          const SizedBox(height: 2),
          const Text('Raj Sharma', style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text('Sales Staff  ·  Surat Region', style: AppTextStyles.caption),
          const SizedBox(height: 24),

          GridView.count(
            crossAxisCount: 2, shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4,
            children: const [
              KpiCard(label: 'Total Orders', value: '48',
                icon: Icons.receipt_long_rounded, color: AppColors.primary),
              KpiCard(label: 'Revenue MTD', value: '₹84.2L',
                icon: Icons.currency_rupee_rounded, color: AppColors.success),
              KpiCard(label: 'Pending', value: '6',
                icon: Icons.hourglass_top_rounded, color: AppColors.warning),
              KpiCard(label: 'Sync Queue', value: '3',
                icon: Icons.sync_rounded, color: AppColors.info,
                sub: 'awaiting upload'),
            ],
          ),
          const SizedBox(height: 28),

          const SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _QuickAction(
              icon: Icons.add_shopping_cart_rounded,
              label: 'New Order', color: AppColors.primary,
              onTap: () => Navigator.push(context,
                MaterialPageRoute(
                  builder: (_) => const CreateOrderScreen())),
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
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: color.withValues(alpha: 0.2),
        highlightColor: color.withValues(alpha: 0.1),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.28)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(label, style: AppTextStyles.caption.copyWith(
                color: color, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
