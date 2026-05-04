import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../shared/widgets/shcc_app_bar.dart';
import '../admin/screens/admin_dashboard_screen.dart';
import '../notifications/notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isAdmin;
  const SettingsScreen({super.key, this.isAdmin = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ── Password change ───────────────────────────────────────────────
  final _formKey    = GlobalKey<FormState>();
  final _oldCtrl    = TextEditingController();
  final _newCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _oldObscure  = true;
  bool _newObscure  = true;
  bool _confObscure = true;
  bool _pwdLoading  = false;

  // ── Theme ─────────────────────────────────────────────────────────
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _isDark = themeNotifier.value == ThemeMode.dark;
    _loadThemePref();
  }

  Future<void> _loadThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    final dark  = prefs.getBool('dark_mode') ?? true;
    setState(() => _isDark = dark);
    themeNotifier.value = dark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleTheme(bool val) async {
    setState(() => _isDark = val);
    themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', val);
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _pwdLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _pwdLoading = false);
    _oldCtrl.clear(); _newCtrl.clear(); _confirmCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text('Password updated successfully',
          style: AppTextStyles.body),
      ]),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  void dispose() {
    _oldCtrl.dispose(); _newCtrl.dispose(); _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

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
          _SectionHeader(
            icon: Icons.palette_outlined,
            title: 'Appearance',
          ),
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

          // ── Security ──────────────────────────────────────────────
          _SectionHeader(
            icon: Icons.lock_outline_rounded,
            title: 'Security',
          ),
          const SizedBox(height: 12),
          _SettingsCard(children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  _PwdField(
                    ctrl: _oldCtrl,
                    label: 'Current Password',
                    obscure: _oldObscure,
                    onToggle: () =>
                      setState(() => _oldObscure = !_oldObscure),
                    validator: (v) => (v == null || v.isEmpty)
                      ? 'Enter current password' : null,
                  ),
                  const SizedBox(height: 14),
                  _PwdField(
                    ctrl: _newCtrl,
                    label: 'New Password',
                    obscure: _newObscure,
                    onToggle: () =>
                      setState(() => _newObscure = !_newObscure),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter new password';
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  _PwdField(
                    ctrl: _confirmCtrl,
                    label: 'Confirm New Password',
                    obscure: _confObscure,
                    onToggle: () =>
                      setState(() => _confObscure = !_confObscure),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
                      if (v != _newCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _pwdLoading ? null : _changePassword,
                      child: _pwdLoading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                        : const Text('Update Password'),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
          const SizedBox(height: 24),

          // ── Admin: Sales Target Management ────────────────────────
          if (widget.isAdmin) ...[
            _SectionHeader(
              icon: Icons.track_changes_rounded,
              title: 'Sales Target Management',
            ),
            const SizedBox(height: 12),
            const _SalesTargetSection(),
            const SizedBox(height: 24),
          ],

          // ── About ─────────────────────────────────────────────────
          _SectionHeader(
            icon: Icons.info_outline_rounded,
            title: 'About',
          ),
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

// ── Sales Target Section (moved from admin dashboard) ─────────────────────────
class _SalesTargetSection extends StatefulWidget {
  const _SalesTargetSection();
  @override
  State<_SalesTargetSection> createState() => _SalesTargetSectionState();
}

class _SalesTargetSectionState extends State<_SalesTargetSection> {
  final _salesPersons = ['Raj Sharma', 'Amit Patel', 'Priya Mehta'];
  String? _selected;
  final _targetCtrl = TextEditingController();
  bool _saved = false;

  @override
  void dispose() { _targetCtrl.dispose(); super.dispose(); }

  String _fmt(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  void _save() {
    final v = double.tryParse(_targetCtrl.text);
    if (_selected == null || v == null || v <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Select a salesperson and enter a valid target'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    setState(() {
      TargetStore.targets[_selected!] = v;
      _saved = true;
      // Trigger a notification for the salesperson
      NotificationStore.add(
        person: _selected!,
        title: 'Target Updated',
        description: 'Your monthly target has been set to ${_fmt(v)} by Admin.',
        type: NotifType.target,
      );
    });
    Future.delayed(const Duration(seconds: 2),
      () { if (mounted) setState(() => _saved = false); });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text('Target updated for $_selected',
          style: AppTextStyles.body),
      ]),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Progress overview
          ...TargetStore.targets.entries.map((e) {
            final achieved = TargetStore.achieved[e.key] ?? 0;
            final pct = e.value == 0
              ? 0.0 : (achieved / e.value).clamp(0.0, 1.0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key, style: AppTextStyles.bodyMedium),
                      Text('${(pct * 100).toStringAsFixed(0)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: pct >= 1
                            ? AppColors.success : AppColors.primary)),
                    ]),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct, minHeight: 6,
                        backgroundColor: AppColors.bgBase,
                        valueColor: AlwaysStoppedAnimation(
                          pct >= 1 ? AppColors.success : AppColors.primary),
                      ),
                    )),
                    const SizedBox(width: 8),
                    Text('${_fmt(achieved)} / ${_fmt(e.value)}',
                      style: AppTextStyles.caption),
                  ]),
                ],
              ),
            );
          }),
          const Divider(color: AppColors.border, height: 24),

          // Assign form
          Text('Assign / Update Target',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary, letterSpacing: 0.6)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selected,
            dropdownColor: Theme.of(context).cardColor,
            style: AppTextStyles.body,
            hint: Text('Select sales person',
              style: AppTextStyles.caption),
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
            decoration: const InputDecoration(
              labelText: 'Sales Person',
              prefixIcon: Icon(Icons.person_outline_rounded,
                size: 18, color: AppColors.textMuted),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            ),
            items: _salesPersons.map((p) => DropdownMenuItem(
              value: p,
              child: Text(p, style: AppTextStyles.body),
            )).toList(),
            onChanged: (v) => setState(() {
              _selected = v;
              if (v != null && TargetStore.targets.containsKey(v)) {
                _targetCtrl.text =
                  TargetStore.targets[v]!.toStringAsFixed(0);
              } else {
                _targetCtrl.clear();
              }
            }),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _targetCtrl,
            style: AppTextStyles.body,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Target (₹)',
              prefixIcon: Icon(Icons.currency_rupee_rounded,
                size: 18, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(_saved
                ? Icons.check_rounded : Icons.save_rounded, size: 16),
              label: Text(_saved ? 'Saved!' : 'Save Target'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                  _saved ? AppColors.success : AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _save,
            ),
          ),
        ]),
      ),
    ]);
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
      Switch(value: value, onChanged: onChanged),
    ]),
  );
}

class _PwdField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PwdField({
    required this.ctrl, required this.label,
    required this.obscure, required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: ctrl,
    obscureText: obscure,
    validator: validator,
    style: AppTextStyles.body,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_outline_rounded,
        size: 18, color: AppColors.textMuted),
      suffixIcon: IconButton(
        icon: Icon(obscure
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined,
          size: 18, color: AppColors.textMuted),
        onPressed: onToggle,
      ),
    ),
  );
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
