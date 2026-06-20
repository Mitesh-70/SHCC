import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/shcc_app_bar.dart';
import '../../shared/widgets/empty_state.dart';

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
  List<AppNotification> get _notifs =>
    NotificationStore.forRecipient(person: widget.person, role: widget.role);

  int get _unread =>
    _notifs.where((n) => !n.isRead).length;

  void _onTap(AppNotification n) {
    setState(() => NotificationStore.markRead(n.id));

    // Navigate based on type
    Navigator.pop(context); // close notifications screen first
    if (widget.onNavigate != null) {
      widget.onNavigate!(n.type, orderId: n.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifs = _notifs;

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
        actions: _unread > 0
          ? [
              TextButton(
                onPressed: () => setState(() =>
                  NotificationStore.markAllReadFor(
                    person: widget.person, role: widget.role)),
                child: Text('Mark all read',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary)),
              ),
            ]
          : null,
      ),
      body: notifs.isEmpty
        ? const EmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No notifications',
            subtitle: 'You are all caught up!',
          )
        : Column(children: [
            if (_unread > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$_unread unread',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                itemCount: notifs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final n = notifs[i];
                  // Section divider between unread and read
                  final showDivider = i > 0 &&
                    !notifs[i - 1].isRead && n.isRead;
                  return Column(children: [
                    if (showDivider)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
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
          ]),
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
        return '→ View Order';
      case NotifType.targetModified:
      case NotifType.targetCompleted: return '→ View Profile';
      case NotifType.catalogueUpdated:return '→ View Catalogue';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    final isRead = notif.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isRead
            ? Theme.of(context).cardColor
            : color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead
              ? Theme.of(context).dividerColor
              : color.withValues(alpha: 0.4),
            width: isRead ? 1 : 1.5,
          ),
          boxShadow: isRead
            ? null
            : [BoxShadow(
                color: color.withValues(alpha: 0.08),
                blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Icon
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isRead ? 0.08 : 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: isRead
              ? color.withValues(alpha: 0.6) : color, size: 20),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(notif.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isRead
                      ? FontWeight.w400 : FontWeight.w700,
                    color: isRead
                      ? Theme.of(context).textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.7)
                      : null,
                  ))),
                if (!isRead)
                  Container(
                    width: 8, height: 8, margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle),
                  ),
              ]),
              const SizedBox(height: 4),
              Text(notif.description,
                style: AppTextStyles.bodySecondary.copyWith(
                  color: isRead
                    ? AppColors.textMuted
                    : AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),

              // Catalogue sub-note
              if (notif.catalogueNote != null) ...[
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
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

              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(notif.timestamp,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted)),
                  Text(_navHint,
                    style: AppTextStyles.caption.copyWith(
                      color: isRead
                        ? AppColors.textMuted
                        : color,
                      fontWeight: isRead
                        ? FontWeight.w400 : FontWeight.w600)),
                ],
              ),
            ],
          )),
        ]),
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