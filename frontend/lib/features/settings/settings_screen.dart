import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/shcc_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  final bool isAdmin;
  const SettingsScreen({super.key, this.isAdmin = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Theme ─────────────────────────────────────────────────────────
  bool _isDark = true;

  // ── Notifications ─────────────────────────────────────────────────
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _isDark = themeNotifier.value == ThemeMode.dark;
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('dark_mode') ?? true;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
    themeNotifier.value = _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleTheme(bool val) async {
    setState(() => _isDark = val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', val);
  }

  Future<void> _toggleNotifications(bool val) async {
    setState(() => _notificationsEnabled = val);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: false,
        title: 'Settings',
        showProfileIcon: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [

          // ── Appearance ────────────────────────────────────────────
          _SectionHeader(icon: Icons.palette_outlined, title: 'Appearance'),
          const SizedBox(height: 12),
          _SettingsCard(children: [
            _ToggleRow(
              icon: Icons.dark_mode_rounded,
              iconColor: const Color(0xFF9B59B6),
              label: 'Dark Mode',
              sub: _isDark ? 'Dark theme active' : 'Light theme active',
              value: _isDark,
              onChanged: _toggleTheme,
            ),
          ]),
          const SizedBox(height: 24),

          // ── Notifications ─────────────────────────────────────────
          _SectionHeader(
            icon: Icons.notifications_outlined, title: 'Notifications'),
          const SizedBox(height: 12),
          _SettingsCard(children: [
            _ToggleRow(
              icon: Icons.notifications_active_rounded,
              iconColor: const Color(0xFF34C759),
              label: 'Push Notifications',
              sub: _notificationsEnabled ? 'Notifications on' : 'Notifications off',
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ]),
          const SizedBox(height: 24),

          // ── Language ──────────────────────────────────────────────
          _SectionHeader(icon: Icons.language_rounded, title: 'Language'),
          const SizedBox(height: 12),
          _SettingsCard(children: [
            _NavRow(
              icon: Icons.translate_rounded,
              iconColor: const Color(0xFF0EA5E9),
              label: 'Language',
              sub: 'English',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),

          // ── About ─────────────────────────────────────────────────
          _SectionHeader(icon: Icons.info_outline_rounded, title: 'About'),
          const SizedBox(height: 12),
          _SettingsCard(children: [
            _InfoRow(icon: Icons.business_rounded,
              label: 'Company', value: 'Shree Hari Coal Corporation'),
            const Divider(height: 1, indent: 56),
            _InfoRow(icon: Icons.phone_android_rounded,
              label: 'App Version', value: '1.0.0'),
            const Divider(height: 1, indent: 56),
            _InfoRow(icon: Icons.support_agent_rounded,
              label: 'Support', value: 'support@shcc.com'),
          ]),
        ],
      ),
    );
  }
}

// ── Small widgets ─────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(children: [
    Container(
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: AppColors.primaryMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 15, color: AppColors.primary),
    ),
    const SizedBox(width: 10),
    Text(title, style: AppTextStyles.heading3),
  ]);
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: children),
  );
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, sub;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleRow({
    required this.icon, required this.iconColor,
    required this.label, required this.sub,
    required this.value, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(sub, style: AppTextStyles.caption),
        ],
      )),
      CupertinoSwitch(
        value: value,
        activeTrackColor: iconColor,
        onChanged: onChanged,
      ),
    ]),
  );
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label, sub;
  final VoidCallback onTap;

  const _NavRow({
    required this.icon, required this.iconColor,
    required this.label, required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyMedium),
              Text(sub, style: AppTextStyles.caption),
            ],
          )),
          Icon(CupertinoIcons.chevron_right,
            size: 16,
            color: isDark ? const Color(0xFF48484A) : const Color(0xFFC7C7CC)),
        ]),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColors.textSecondary),
      const SizedBox(width: 14),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 1),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      )),
    ]),
  );
}
