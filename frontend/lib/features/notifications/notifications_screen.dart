import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/shcc_app_bar.dart';
import '../../shared/widgets/empty_state.dart';

// ── Notification types ────────────────────────────────────────────────────────
enum NotifType { orderConfirmed, orderRejected, priceChange, availability, target, catalogue }

// ── Notification model ────────────────────────────────────────────────────────
class AppNotification {
  final String id, person, title, description, timestamp;
  final NotifType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.person,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

// ── Global notification store ─────────────────────────────────────────────────
class NotificationStore {
  static final List<AppNotification> _items = [
    AppNotification(
      id: 'N001', person: 'Raj Sharma',
      title: 'Order Confirmed',
      description: 'Your order ORD-2024-047 has been approved by Admin.',
      timestamp: '2 min ago', type: NotifType.orderConfirmed,
    ),
    AppNotification(
      id: 'N002', person: 'Raj Sharma',
      title: 'Price Updated',
      description: 'Indonesian Coal price updated to ₹6,400/MT.',
      timestamp: '1 hr ago', type: NotifType.priceChange,
    ),
    AppNotification(
      id: 'N003', person: 'Raj Sharma',
      title: 'Order Rejected',
      description: 'ORD-2024-045 was rejected. Check admin comment.',
      timestamp: '3 hrs ago', type: NotifType.orderRejected,
    ),
    AppNotification(
      id: 'N004', person: 'Raj Sharma',
      title: 'Availability Changed',
      description: 'Bio Coal is now unavailable. Catalogue updated.',
      timestamp: 'Yesterday', type: NotifType.availability,
    ),
    AppNotification(
      id: 'N005', person: 'Raj Sharma',
      title: 'Catalogue Updated',
      description: 'Admin has updated the product catalogue.',
      timestamp: '2 days ago', type: NotifType.catalogue,
    ),
  ];

  static List<AppNotification> forPerson(String person) =>
    _items.where((n) => n.person == person).toList();

  static int unreadCount(String person) =>
    _items.where((n) => n.person == person && !n.isRead).length;

  static void add({
    required String person,
    required String title,
    required String description,
    required NotifType type,
  }) {
    _items.insert(0, AppNotification(
      id: 'N${DateTime.now().millisecondsSinceEpoch}',
      person: person, title: title, description: description,
      timestamp: 'Just now', type: type,
    ));
  }

  static void markRead(String id) {
    final idx = _items.indexWhere((n) => n.id == id);
    if (idx != -1) _items[idx].isRead = true;
  }

  static void markAllRead(String person) {
    for (final n in _items) {
      if (n.person == person) n.isRead = true;
    }
  }
}

// ── Notifications Screen ──────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  final String person;
  const NotificationsScreen({super.key, required this.person});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final notifs = NotificationStore.forPerson(widget.person);
    final unread = notifs.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Notifications',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: unread > 0
          ? [TextButton(
              onPressed: () => setState(() =>
                NotificationStore.markAllRead(widget.person)),
              child: Text('Mark all read',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary)),
            )]
          : null,
      ),
      body: notifs.isEmpty
        ? const EmptyState(
            icon: Icons.notifications_none_rounded,
            title: 'No notifications',
            subtitle: 'You are all caught up!',
          )
        : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: notifs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final n = notifs[i];
              return _NotifCard(
                notif: n,
                onTap: () => setState(() => NotificationStore.markRead(n.id)),
              );
            },
          ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification notif;
  final VoidCallback onTap;
  const _NotifCard({required this.notif, required this.onTap});

  IconData get _icon {
    switch (notif.type) {
      case NotifType.orderConfirmed: return Icons.check_circle_outline_rounded;
      case NotifType.orderRejected:  return Icons.cancel_outlined;
      case NotifType.priceChange:    return Icons.currency_rupee_rounded;
      case NotifType.availability:   return Icons.inventory_2_outlined;
      case NotifType.target:         return Icons.track_changes_rounded;
      case NotifType.catalogue:      return Icons.list_alt_rounded;
    }
  }

  Color get _color {
    switch (notif.type) {
      case NotifType.orderConfirmed: return AppColors.success;
      case NotifType.orderRejected:  return AppColors.error;
      case NotifType.priceChange:    return AppColors.warning;
      case NotifType.availability:   return AppColors.info;
      case NotifType.target:         return AppColors.primary;
      case NotifType.catalogue:      return const Color(0xFF9B59B6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead
            ? Theme.of(context).cardColor
            : _color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: notif.isRead
              ? AppColors.border
              : _color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: _color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: _color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(child: Text(notif.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: notif.isRead
                      ? FontWeight.w400 : FontWeight.w600))),
                if (!notif.isRead)
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: _color, shape: BoxShape.circle),
                  ),
              ]),
              const SizedBox(height: 4),
              Text(notif.description,
                style: AppTextStyles.bodySecondary,
                maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text(notif.timestamp,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted)),
            ],
          )),
        ]),
      ),
    );
  }
}

// ── Bell icon widget (used in AppBar) ─────────────────────────────────────────
class NotificationBell extends StatelessWidget {
  final String person;
  const NotificationBell({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    final count = NotificationStore.unreadCount(person);
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) =>
          NotificationsScreen(person: person))),
      child: Container(
        margin: const EdgeInsets.only(right: 4),
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.notifications_outlined,
              size: 18, color: AppColors.textSecondary),
          ),
          if (count > 0)
            Positioned(
              top: -3, right: -3,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text('$count',
                  style: const TextStyle(
                    color: Colors.white, fontSize: 9,
                    fontWeight: FontWeight.w700)),
              ),
            ),
        ]),
      ),
    );
  }
}
