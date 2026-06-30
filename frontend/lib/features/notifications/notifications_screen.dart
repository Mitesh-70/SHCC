import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/shcc_app_bar.dart';
import '../../shared/widgets/empty_state.dart';
import '../../core/constants/app_constants.dart';

// ── Notification types ────────────────────────────────────────────────────────
enum NotifType {
  orderAccepted,
  orderRejected,
  orderCreated,
  orderApproved,
  orderOnHold,
  holdReleased,
  dispatchUpdated,
  targetModified,
  targetCompleted,
  catalogueUpdated,
}

// ── Notification model ────────────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String person;
  final String title;
  final String description;
  final String timestamp;
  final NotifType type;
  final String? orderId;
  final String? catalogueNote;
  final List<String>? roles;
  bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.person,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.orderId,
    this.catalogueNote,
    this.roles,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get category {
    switch (type) {
      case NotifType.orderAccepted:
      case NotifType.orderApproved:
      case NotifType.orderRejected:
      case NotifType.orderCreated:
      case NotifType.orderOnHold:
      case NotifType.holdReleased:
        return 'Orders';
      case NotifType.dispatchUpdated:
        return 'Delivery';
      case NotifType.targetModified:
      case NotifType.targetCompleted:
        return 'Targets';
      case NotifType.catalogueUpdated:
        return 'System Updates';
    }
  }
}

// ── Global notification store ─────────────────────────────────────────────────
class NotificationStore {
  static final List<AppNotification> _items = [
    AppNotification(
      id: 'N001', person: 'Raj Sharma',
      title: 'Order Accepted',
      description: 'Your order ORD-2024-047 has been approved by Admin.',
      timestamp: '2 min ago', type: NotifType.orderAccepted,
      orderId: 'ORD-2024-047',
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    AppNotification(
      id: 'N002', person: 'Raj Sharma',
      title: 'Catalogue Updated',
      description: 'Admin updated the product catalogue.',
      timestamp: '1 hr ago', type: NotifType.catalogueUpdated,
      catalogueNote: 'Price updated',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    AppNotification(
      id: 'N003', person: 'Raj Sharma',
      title: 'Order Rejected',
      description: 'Order ORD-2024-045 was rejected. Review admin comment.',
      timestamp: '3 hrs ago', type: NotifType.orderRejected,
      orderId: 'ORD-2024-045',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AppNotification(
      id: 'N004', person: 'Raj Sharma',
      title: 'Target Updated',
      description: 'Admin has updated your monthly sales target.',
      timestamp: 'Yesterday', type: NotifType.targetModified,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppNotification(
      id: 'N005', person: 'Raj Sharma',
      title: 'Target Completed!',
      description: 'Congratulations! You have achieved your monthly target.',
      timestamp: '2 days ago', type: NotifType.targetCompleted,
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AppNotification(
      id: 'N006', person: 'Raj Sharma',
      title: 'Catalogue Updated',
      description: 'Admin updated the product catalogue.',
      timestamp: '3 days ago', type: NotifType.catalogueUpdated,
      catalogueNote: 'Availability updated',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  /// Returns notifications for a person and/or role.
  static List<AppNotification> forRecipient({
    required String person,
    String? role,
  }) {
    final all = _items.where((n) {
      if (n.person == person) return true;
      if (role != null && n.roles != null && n.roles!.contains(role)) {
        return true;
      }
      return false;
    }).toList();
    final unread = all.where((n) => !n.isRead).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final read = all.where((n) => n.isRead).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [...unread, ...read];
  }

  /// Backward-compatible alias.
  static List<AppNotification> forPerson(String person) =>
      forRecipient(person: person);

  static int unreadCountFor({required String person, String? role}) =>
    _items.where((n) {
      if (n.isRead) return false;
      if (n.person == person) return true;
      if (role != null && n.roles != null && n.roles!.contains(role)) {
        return true;
      }
      return false;
    }).length;

  static int unreadCount(String person) =>
      unreadCountFor(person: person);

  static void add({
    required String person,
    required String title,
    required String description,
    required NotifType type,
    String? orderId,
    String? catalogueNote,
    List<String>? roles,
  }) {
    _items.insert(0, AppNotification(
      id: 'N${DateTime.now().millisecondsSinceEpoch}',
      person: person, title: title, description: description,
      timestamp: 'Just now', type: type,
      orderId: orderId, catalogueNote: catalogueNote, roles: roles,
    ));
  }

  static void notifyPortAdminsForOrder({
    required Map<String, dynamic> order,
    required String title,
    required String description,
    required NotifType type,
  }) {
    final port = order['port_name'] as String?;
    if (port == null) return;
    for (final pa in PortAdminStore.users) {
      if (pa.isActive && pa.assignedPorts.contains(port)) {
        add(
          person: pa.name,
          roles: ['port_admin'],
          title: title,
          description: description,
          type: type,
          orderId: order['id'] as String,
        );
      }
    }
  }

  static void markAllReadFor({required String person, String? role}) {
    for (final n in _items) {
      if (n.person == person) n.isRead = true;
      if (role != null && n.roles != null && n.roles!.contains(role)) {
        n.isRead = true;
      }
    }
  }

  static void markRead(String id) {
    final idx = _items.indexWhere((n) => n.id == id);
    if (idx != -1) _items[idx].isRead = true;
  }

  static void markAllRead(String person) => markAllReadFor(person: person);
}

// ── Navigation callback type ──────────────────────────────────────────────────
typedef NotifNavCallback = void Function(NotifType type, {String? orderId});

// ── Notifications Screen ──────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  final String person;
  final String? role;
  final NotifNavCallback? onNavigate;

  const NotificationsScreen({
    super.key,
    required this.person,
    this.role,
    this.onNavigate,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';

  List<AppNotification> get _notifs {
    final all = NotificationStore.forRecipient(person: widget.person, role: widget.role);
    if (_selectedCategory == 'All') return all;
    return all.where((n) => n.category == _selectedCategory).toList();
  }

  int get _totalUnread =>
    NotificationStore.unreadCountFor(person: widget.person, role: widget.role);

  void _onTap(AppNotification n) {
    setState(() => NotificationStore.markRead(n.id));

    // Navigate based on type
    Navigator.pop(context); // close notifications screen first
    if (widget.onNavigate != null) {
      widget.onNavigate!(n.type, orderId: n.orderId);
    }
  }

  Widget _buildCategoryFilters(bool isDark) {
    final categories = [
      {'label': 'All', 'value': 'All', 'icon': Icons.grid_view_rounded},
      {'label': 'Orders', 'value': 'Orders', 'icon': Icons.shopping_bag_outlined},
      {'label': 'Delivery', 'value': 'Delivery', 'icon': Icons.local_shipping_outlined},
      {'label': 'Targets', 'value': 'Targets', 'icon': Icons.track_changes_rounded},
      {'label': 'System', 'value': 'System Updates', 'icon': Icons.settings_outlined},
    ];
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat['value'];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat['value'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBgCard : AppColors.lightBgCard),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    cat['label'] as String,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _notifs;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Notifications',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _totalUnread > 0
          ? [
              TextButton.icon(
                onPressed: () => setState(() =>
                  NotificationStore.markAllReadFor(
                    person: widget.person, role: widget.role)),
                icon: const Icon(Icons.done_all_rounded, size: 18, color: AppColors.primary),
                label: Text('Mark all read',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
            ]
          : null,
      ),
      body: Column(
        children: [
          _buildCategoryFilters(isDark),
          Expanded(
            child: notifs.isEmpty
                ? EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: 'No notifications',
                    subtitle: _selectedCategory == 'All'
                        ? 'You are all caught up!'
                        : 'No notifications found in $_selectedCategory.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    itemCount: notifs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final n = notifs[i];
                      // Section divider between unread and read
                      final showDivider = i > 0 &&
                        !notifs[i - 1].isRead && n.isRead;
                      return Column(children: [
                        if (showDivider)
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            child: Row(children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                                child: Text('Earlier',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textMuted)),
                              ),
                              const Expanded(child: Divider()),
                            ]),
                          ),
                        _NotifCard(
                          notif: n,
                          onTap: () => _onTap(n),
                        ),
                      ]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotifCard extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  const _NotifCard({required this.notif, required this.onTap});

  IconData get _icon {
    switch (notif.type) {
      case NotifType.orderAccepted:
      case NotifType.orderApproved:
        return Icons.check_circle_outline_rounded;
      case NotifType.orderRejected:   return Icons.cancel_outlined;
      case NotifType.orderCreated:    return Icons.add_shopping_cart_outlined;
      case NotifType.orderOnHold:     return Icons.pause_circle_outline;
      case NotifType.holdReleased:    return Icons.play_circle_outline;
      case NotifType.dispatchUpdated: return Icons.local_shipping_outlined;
      case NotifType.targetModified:  return Icons.track_changes_rounded;
      case NotifType.targetCompleted: return Icons.emoji_events_outlined;
      case NotifType.catalogueUpdated:return Icons.inventory_2_outlined;
    }
  }

  Color get _color {
    switch (notif.type) {
      case NotifType.orderAccepted:
      case NotifType.orderApproved:
      case NotifType.holdReleased:
        return AppColors.success;
      case NotifType.orderRejected:   return AppColors.error;
      case NotifType.orderCreated:    return AppColors.info;
      case NotifType.orderOnHold:     return AppColors.warning;
      case NotifType.dispatchUpdated: return const Color(0xFF14B8A6);
      case NotifType.targetModified:  return AppColors.primary;
      case NotifType.targetCompleted: return const Color(0xFFFFCC00);
      case NotifType.catalogueUpdated:return AppColors.info;
    }
  }

  String get _navHint {
    switch (notif.type) {
      case NotifType.orderAccepted:
      case NotifType.orderApproved:
      case NotifType.orderRejected:
      case NotifType.orderCreated:
      case NotifType.orderOnHold:
      case NotifType.holdReleased:
      case NotifType.dispatchUpdated:
        return 'View Order';
      case NotifType.targetModified:
      case NotifType.targetCompleted: return 'View Profile';
      case NotifType.catalogueUpdated:return 'View Catalogue';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final isRead = notif.isRead;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isRead
            ? (isDark ? AppColors.darkBgCard : Colors.white)
            : (isDark ? const Color(0xFF131B2A) : color.withValues(alpha: 0.05)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
              ? AppColors.border
              : color.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isRead
            ? null
            : [BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isRead)
                  Container(
                    width: 4,
                    color: color,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: isRead ? 0.08 : 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(_icon, color: isRead
                            ? color.withValues(alpha: 0.6) : color, size: 24),
                        ),
                        const SizedBox(width: 16),

                        // Content
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row 1: Tag and Unread Dot
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    notif.category.toUpperCase(),
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                if (!isRead)
                                  Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(
                                      color: color, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Row 2: Title
                            Text(notif.title,
                                style: AppTextStyles.heading3.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isRead
                                    ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                                    : (isDark ? Colors.white : AppColors.lightTextPrimary),
                                )),
                            const SizedBox(height: 6),
                            // Row 3: Description
                            Text(notif.description,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isRead
                                    ? AppColors.textMuted
                                    : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis),

                            // Catalogue sub-note
                            if (notif.catalogueNote != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.info.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(notif.catalogueNote!,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.info,
                                    fontWeight: FontWeight.w600)),
                              ),
                            ],

                            const SizedBox(height: 16),
                            // Row 4: Bottom row (time + nav hint)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: AppColors.textMuted),
                                    const SizedBox(width: 4),
                                    Text(notif.timestamp,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textMuted)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(_navHint,
                                      style: AppTextStyles.caption.copyWith(
                                        color: isRead ? AppColors.textMuted : color,
                                        fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 14, 
                                      color: isRead ? AppColors.textMuted : color),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Bell icon widget ──────────────────────────────────────────────────────────
class NotificationBell extends StatefulWidget {
  final String person;
  final String? role;
  final NotifNavCallback? onNavigate;

  const NotificationBell({
    super.key,
    required this.person,
    this.role,
    this.onNavigate,
  });

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  Widget build(BuildContext context) {
    final count = NotificationStore.unreadCountFor(
      person: widget.person, role: widget.role);

    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(
          builder: (_) => NotificationsScreen(
            person: widget.person,
            role: widget.role,
            onNavigate: widget.onNavigate,
          ),
        ));
        // Rebuild bell after returning to reflect read state
        if (mounted) setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 36, height: 36,
            alignment: Alignment.center,
            child: Icon(
              count > 0
                ? Icons.notifications_rounded
                : Icons.notifications_outlined,
              size: 26,
              color: count > 0
                ? AppColors.primary : AppColors.textSecondary),
          ),
          if (count > 0)
            Positioned(
              top: 0, right: 2,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 20, minHeight: 20),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2),
                ),
                child: Center(
                  child: Text(
                    count > 9 ? '9+' : '$count',
                    style: const TextStyle(
                      color: Colors.white, fontSize: 11,
                      fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}