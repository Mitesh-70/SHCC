import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../notifications/notifications_screen.dart';

class PortAdminManagementScreen extends StatefulWidget {
  const PortAdminManagementScreen({super.key});
  @override
  State<PortAdminManagementScreen> createState() =>
      _PortAdminManagementScreenState();
}

class _PortAdminManagementScreenState extends State<PortAdminManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Port Admin Management',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Port Admin'),
      ),
      body: PortAdminStore.users.isEmpty
          ? const EmptyState(
              icon: Icons.people_outline_rounded,
              title: 'No Port Admins',
              subtitle: 'Create a port admin to assign ports.',
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: PortAdminStore.users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _PortAdminCard(
                user: PortAdminStore.users[i],
                onChanged: () => setState(() {}),
              ),
            ),
    );
  }

  Future<void> _showCreateDialog() async {
    final data = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => const _CreatePortAdminDialog(),
    );

    if (data != null) {
      final id = 'pa-${DateTime.now().millisecondsSinceEpoch}';
      final name = data['name'] as String;
      final assigned = data['assignedPorts'] as List<String>;
      PortAdminStore.users.add(PortAdminUser(
        id: id,
        name: name,
        username: data['username'] as String,
        assignedPorts: assigned,
      ));
      setState(() {});
      
      NotificationStore.add(
        person: 'Admin',
        roles: ['admin'],
        title: 'Port Assignment Changed',
        description: 'New Port Admin $name registered with ports: ${assigned.join(', ')}.',
        type: NotifType.portAssignment,
      );

      NotificationStore.add(
        person: name,
        roles: ['port_admin'],
        title: 'Port Reassignment Updates',
        description: 'Welcome! You have been assigned the following ports: ${assigned.join(', ')}.',
        type: NotifType.portAssignment,
      );
    }
  }
}

class _PortAdminCard extends StatelessWidget {
  final PortAdminUser user;
  final VoidCallback onChanged;

  const _PortAdminCard({required this.user, required this.onChanged});

  Future<void> _editPorts(BuildContext context) async {
    final selected = Set<String>.from(user.assignedPorts);
    final activeAssigned = PortAdminStore.getActiveAssignedPorts(excludeUserId: user.id);
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          title: Text('Assign Ports — ${user.name}'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: AppConstants.ports.map((p) {
                final sel = selected.contains(p);
                final isAssigned = activeAssigned.contains(p);
                return FilterChip(
                  label: isAssigned ? Text('$p (assigned)') : Text(p),
                  selected: sel,
                  onSelected: isAssigned
                      ? null
                      : (v) => setDialog(() {
                            if (v) {
                              selected.add(p);
                            } else {
                              selected.remove(p);
                            }
                          }),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) {
      user.assignedPorts
        ..clear()
        ..addAll(selected);
      onChanged();

      NotificationStore.add(
        person: 'Admin',
        roles: ['admin'],
        title: 'Port Assignment Changed',
        description: 'Ports reassigned for ${user.name}: ${selected.join(', ')}.',
        type: NotifType.portAssignment,
      );

      NotificationStore.add(
        person: user.name,
        roles: ['port_admin'],
        title: 'Port Reassignment Updates',
        description: 'Your managed ports have been updated to: ${selected.join(', ')}.',
        type: NotifType.portAssignment,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryMuted,
                child: Text(user.name[0],
                    style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTextStyles.bodyMedium),
                    Text('@${user.username}',
                        style: AppTextStyles.caption),
                  ],
                ),
              ),
              Switch(
                value: user.isActive,
                onChanged: (v) {
                  user.isActive = v;
                  onChanged();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: user.assignedPorts
                .map((p) => Chip(
                      label: Text(p, style: AppTextStyles.caption),
                      backgroundColor: AppColors.primaryMuted,
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _editPorts(context),
                icon: const Icon(Icons.edit_location_alt_outlined, size: 16),
                label: const Text('Reassign Ports'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  PortAdminStore.users.remove(user);
                  onChanged();
                },
                child: Text('Remove',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatePortAdminDialog extends StatefulWidget {
  const _CreatePortAdminDialog();

  @override
  State<_CreatePortAdminDialog> createState() => _CreatePortAdminDialogState();
}

class _CreatePortAdminDialogState extends State<_CreatePortAdminDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _userCtrl;
  final Set<String> _selected = {};
  late final Set<String> _activeAssigned;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _userCtrl = TextEditingController();
    _activeAssigned = PortAdminStore.getActiveAssignedPorts();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _userCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Port Admin'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 12),
            Text('Assign Ports', style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: AppConstants.ports.map((p) {
                final sel = _selected.contains(p);
                final isAssigned = _activeAssigned.contains(p);
                return FilterChip(
                  label: isAssigned ? Text('$p (assigned)') : Text(p),
                  selected: sel,
                  onSelected: isAssigned
                      ? null
                      : (v) {
                          setState(() {
                            if (v) {
                              _selected.add(p);
                            } else {
                              _selected.remove(p);
                            }
                          });
                        },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            final username = _userCtrl.text.trim().toLowerCase();
            if (name.isEmpty || username.isEmpty || _selected.isEmpty) {
              return;
            }
            Navigator.pop(context, {
              'name': name,
              'username': username,
              'assignedPorts': _selected.toList(),
            });
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
