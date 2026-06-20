import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ShccBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isAdmin;
  final bool isPortAdmin;

  const ShccBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isAdmin = false,
    this.isPortAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items  = isPortAdmin
        ? _portAdminItems()
        : isAdmin
            ? _adminItems()
            : _salesItems();
    final bg     = isDark ? const Color(0xFF111111) : Colors.white;
    final shadow = isDark
      ? const Color(0x40000000)
      : const Color(0x12000000);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(
            color: isDark
              ? AppColors.border.withValues(alpha: 0.5)
              : AppColors.lightBorder,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) =>
              _NavItem(
                item: items[i],
                isSelected: currentIndex == i,
                onTap: () => onTap(i),
                isDark: isDark,
              )),
          ),
        ),
      ),
    );
  }

  List<_BottomNavData> _salesItems() => const [
    _BottomNavData(icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded, label: 'Home'),
    _BottomNavData(icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded, label: 'Search'),
    _BottomNavData(icon: Icons.add_circle_outline_rounded,
      activeIcon: Icons.add_circle_rounded, label: 'Order',
      isCenter: true),
    _BottomNavData(icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded, label: 'Catalogue'),
    _BottomNavData(icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  List<_BottomNavData> _adminItems() => const [
    _BottomNavData(icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded, label: 'Home'),
    _BottomNavData(icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded, label: 'Search'),
    _BottomNavData(icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded, label: 'Reports'),
    _BottomNavData(icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded, label: 'Catalogue'),
    _BottomNavData(icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  List<_BottomNavData> _portAdminItems() => const [
    _BottomNavData(icon: Icons.grid_view_rounded,
      activeIcon: Icons.grid_view_rounded, label: 'Home'),
    _BottomNavData(icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded, label: 'Search'),
    _BottomNavData(icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded, label: 'Profile'),
  ];
}

// ── Nav item data ─────────────────────────────────────────────────────────────
class _BottomNavData {
  final IconData icon, activeIcon;
  final String label;
  final bool isCenter;
  const _BottomNavData({
    required this.icon, required this.activeIcon,
    required this.label, this.isCenter = false,
  });
}

// ── Individual nav item ───────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final _BottomNavData item;
  final bool isSelected, isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.item, required this.isSelected,
    required this.onTap, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor   = AppColors.primary;
    final inactiveColor = isDark
      ? const Color(0xFF5A5A5A)
      : const Color(0xFFAAAAAA);

    if (item.isCenter) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.primaryMuted,
            shape: BoxShape.circle,
            boxShadow: isSelected
              ? [BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : null,
          ),
          child: Icon(
            isSelected ? item.activeIcon : item.icon,
            color: isSelected ? Colors.white : AppColors.primary,
            size: 22,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: isSelected ? 40 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected
                  ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? activeColor : inactiveColor,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
