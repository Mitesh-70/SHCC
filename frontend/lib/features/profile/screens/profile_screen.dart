import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../settings/settings_screen.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../notifications/notifications_screen.dart';

// ── Edit Profile Screen ───────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl  = TextEditingController(text: 'Sarah Jenkins');
  final _emailCtrl = TextEditingController(text: 'sarah.jenkins@email.com');
  final _phoneCtrl = TextEditingController(text: '+91 98765 43210');

  // Password fields
  final _formKey    = GlobalKey<FormState>();
  final _oldCtrl    = TextEditingController();
  final _newCtrl    = TextEditingController();
  final _confCtrl   = TextEditingController();
  bool _oldObscure  = true;
  bool _newObscure  = true;
  bool _confObscure = true;
  bool _pwdLoading  = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    _oldCtrl.dispose();  _newCtrl.dispose();   _confCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _pwdLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _pwdLoading = false);
    _oldCtrl.clear(); _newCtrl.clear(); _confCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text('Password updated successfully', style: AppTextStyles.body),
      ]),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.darkBgBase : const Color(0xFFF4F3F0);
    final card   = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Edit Profile',
          style: AppTextStyles.heading1.copyWith(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
            color: AppColors.textPrimaryColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        children: [
          // ── Profile Info Section ────────────────────────────────
          _sectionLabel('Profile Information', isDark),
          const SizedBox(height: 10),
          _card(card, [
            _textField(_nameCtrl,  'Full Name',  Icons.person_outline_rounded),
            _divider(isDark),
            _textField(_emailCtrl, 'Email',      Icons.email_outlined),
            _divider(isDark),
            _textField(_phoneCtrl, 'Phone',      Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          ]),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Profile saved', style: AppTextStyles.body),
                  backgroundColor: Theme.of(context).cardColor,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Save Profile'),
            ),
          ),
          const SizedBox(height: 28),

          // ── Change Password Section ──────────────────────────────
          _sectionLabel('Change Password', isDark),
          const SizedBox(height: 10),
          _card(card, [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  _pwdField(_oldCtrl, 'Current Password',
                    _oldObscure, () => setState(() => _oldObscure = !_oldObscure),
                    (v) => (v == null || v.isEmpty) ? 'Enter current password' : null),
                  const SizedBox(height: 14),
                  _pwdField(_newCtrl, 'New Password',
                    _newObscure, () => setState(() => _newObscure = !_newObscure),
                    (v) {
                      if (v == null || v.isEmpty) return 'Enter new password';
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    }),
                  const SizedBox(height: 14),
                  _pwdField(_confCtrl, 'Confirm New Password',
                    _confObscure, () => setState(() => _confObscure = !_confObscure),
                    (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
                      if (v != _newCtrl.text) return 'Passwords do not match';
                      return null;
                    }),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _pwdLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                      child: _pwdLoading
                        ? const SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                        : const Text('Save Changes'),
                    ),
                  ),
                ]),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 4),
    child: Text(text, style: AppTextStyles.heading2.copyWith(
      fontWeight: FontWeight.bold, fontSize: 15,
      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1C1C1E),
    )),
  );

  Widget _card(Color bg, List<Widget> children) => Container(
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 14, offset: const Offset(0, 4))],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Column(children: children),
    ),
  );

  Widget _divider(bool isDark) => Divider(
    height: 1, thickness: 0.5, indent: 50,
    color: isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5EA),
  );

  Widget _textField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType? keyboardType}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );

  Widget _pwdField(
    TextEditingController ctrl, String label, bool obscure,
    VoidCallback onToggle, String? Function(String?) validator,
  ) =>
    TextFormField(
      controller: ctrl,
      obscureText: obscure,
      validator: validator,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock_outline_rounded,
          size: 18, color: AppColors.textMuted),
        suffixIcon: IconButton(
          icon: Icon(obscure
            ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18, color: AppColors.textMuted),
          onPressed: onToggle,
        ),
      ),
    );
}

// ── Target Management Screen (Admin only) ─────────────────────────────────────
class TargetManagementScreen extends StatefulWidget {
  const TargetManagementScreen({super.key});
  @override
  State<TargetManagementScreen> createState() => _TargetManagementScreenState();
}

class _TargetManagementScreenState extends State<TargetManagementScreen> {
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
      NotificationStore.add(
        person: _selected!,
        title: 'Target Updated',
        description: 'Your monthly target has been set to ${_fmt(v)} by Admin.',
        type: NotifType.targetModified,
      );
    });
    Future.delayed(const Duration(seconds: 2),
      () { if (mounted) setState(() => _saved = false); });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text('Target updated for $_selected', style: AppTextStyles.body),
      ]),
      backgroundColor: Theme.of(context).cardColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg   = isDark ? AppColors.darkBgBase : const Color(0xFFF4F3F0);
    final card = isDark ? const Color(0xFF1C1C1E) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text('Target Management',
          style: AppTextStyles.heading1.copyWith(
            fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18,
            color: AppColors.textPrimaryColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // ── Progress Overview ──────────────────────────────────
          _label('Sales Target Overview', isDark),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: TargetStore.targets.entries.map((e) {
                final achieved = TargetStore.achieved[e.key] ?? 0;
                final pct = e.value == 0
                  ? 0.0 : (achieved / e.value).clamp(0.0, 1.0);
                final color = pct >= 1 ? AppColors.success : AppColors.primary;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.primaryMuted,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text(
                            e.key.substring(0, 1),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                          )),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.key,
                          style: AppTextStyles.bodyMedium)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${(pct * 100).toStringAsFixed(0)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: color, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: pct, minHeight: 8,
                          backgroundColor: AppColors.bgBase,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Achieved: ${_fmt(achieved)}',
                            style: AppTextStyles.caption),
                          Text('Target: ${_fmt(e.value)}',
                            style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // ── Assign / Update Target ─────────────────────────────
          _label('Assign / Update Target', isDark),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Column(children: [
              DropdownButtonFormField<String>(
                value: _selected,
                dropdownColor: card,
                style: AppTextStyles.body,
                hint: Text('Select sales person',
                  style: AppTextStyles.caption),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textMuted),
                decoration: InputDecoration(
                  labelText: 'Sales Person',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                    size: 18, color: AppColors.textMuted),
                  contentPadding: const EdgeInsets.symmetric(
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
              const SizedBox(height: 14),
              TextFormField(
                controller: _targetCtrl,
                style: AppTextStyles.body,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Target (₹)',
                  prefixIcon: Icon(Icons.currency_rupee_rounded,
                    size: 18, color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(_saved
                    ? Icons.check_rounded : Icons.save_rounded, size: 16),
                  label: Text(_saved ? 'Saved!' : 'Save Target'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                      _saved ? AppColors.success : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 13)),
                  onPressed: _save,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, bool isDark) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 2),
    child: Text(text, style: AppTextStyles.heading2.copyWith(
      fontWeight: FontWeight.bold, fontSize: 15,
      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1C1C1E),
    )),
  );
}

// ── Main Profile Screen ───────────────────────────────────────────────────────
class ProfileScreen extends StatelessWidget {
  final bool isAdmin;
  /// Called when the user wants to go back while Profile is embedded
  /// as a tab (not pushed). The dashboard uses this to switch to Home.
  final VoidCallback? onGoHome;
  const ProfileScreen({
    super.key,
    this.isAdmin = false,
    this.onGoHome,
  });

  static const String _name     = 'Sarah Jenkins';
  static const String _email    = 'sarah.jenkins@email.com';
  static const String _imageUrl =
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? AppColors.darkBgBase : const Color(0xFFF4F3F0);
    final card   = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final divCol = isDark ? const Color(0xFF2E2E2E) : const Color(0xFFE5E5EA);
    final textPri= isDark ? Colors.white : Colors.black;
    final textSec= isDark ? AppColors.darkTextSecondary : const Color(0xFF8E8E93);

    return PopScope(
      // When the profile is a tab, intercept back and go to Home instead
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && onGoHome != null) onGoHome!();
      },
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: Text('Profile & Settings',
            style: AppTextStyles.heading1.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20,
              // Explicitly adapt text color so it's always visible
              color: isDark ? Colors.white : Colors.black,
            )),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          // Set foreground color so the icon inherits the right tint
          foregroundColor: isDark ? Colors.white : Colors.black,
          automaticallyImplyLeading: false,
          leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  // Hardcode color from local isDark — avoids AppBar override
                  color: isDark ? Colors.white : Colors.black),
                onPressed: () => Navigator.pop(context))
            : null,
        ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
        children: [
          // ── Avatar & Name ─────────────────────────────────────
          Center(
            child: Column(children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16, offset: const Offset(0, 5))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        _imageUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.primaryMuted,
                          child: const Center(child: Text('SJ',
                            style: TextStyle(color: AppColors.primary,
                              fontSize: 32, fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),
                  ),
                  // Pencil edit button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Change profile photo',
                          style: AppTextStyles.body),
                        backgroundColor: Theme.of(context).cardColor,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      ));
                    },
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: bg, width: 2),
                        boxShadow: [BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 6, offset: const Offset(0, 2))],
                      ),
                      child: const Icon(Icons.edit_rounded,
                        color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(_name, style: AppTextStyles.heading1.copyWith(
                fontWeight: FontWeight.bold, fontSize: 22, color: textPri)),
              const SizedBox(height: 4),
              Text(_email, style: AppTextStyles.bodySecondary.copyWith(
                fontSize: 14, color: textSec)),
            ]),
          ),
          const SizedBox(height: 28),

          // ── Group 1: Navigation Actions ───────────────────────
          _buildCardGroup(card, divCol, [
            _tile(context, card, textPri,
              title: 'Edit Profile',
              leading: CupertinoIcons.pencil,
              iconBg: const Color(0xFF3B82F6),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => const EditProfileScreen()))),
            _tile(context, card, textPri,
              title: 'Payment Methods',
              leading: CupertinoIcons.creditcard,
              iconBg: const Color(0xFF8B5CF6)),
            _tile(context, card, textPri,
              title: 'Settings',
              leading: CupertinoIcons.settings,
              iconBg: const Color(0xFF10B981),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => SettingsScreen(isAdmin: isAdmin)))),
            _tile(context, card, textPri,
              title: 'Help',
              leading: CupertinoIcons.question_circle,
              iconBg: const Color(0xFFF59E0B)),
          ]),
          const SizedBox(height: 24),

          // ── Group 2: Account (Admin only – Target Management) ──
          if (isAdmin) ...[
            _sectionHeader('Account', isDark),
            const SizedBox(height: 8),
            _buildCardGroup(card, divCol, [
              _tile(context, card, textPri,
                title: 'Target Management',
                leading: Icons.track_changes_rounded,
                iconBg: const Color(0xFF0EA5E9),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const TargetManagementScreen()))),
            ]),
            const SizedBox(height: 32),
          ] else
            const SizedBox(height: 12),

          // ── Logout ────────────────────────────────────────────
          TextButton(
            onPressed: () =>
              Navigator.pushReplacementNamed(context, '/login'),
            child: Text('Log Out', style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
          ),
        ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title, bool isDark) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 4),
    child: Text(title, style: AppTextStyles.heading2.copyWith(
      fontWeight: FontWeight.bold, fontSize: 16,
      color: isDark ? AppColors.darkTextPrimary : const Color(0xFF1C1C1E),
    )),
  );

  Widget _buildCardGroup(Color card, Color divCol, List<Widget> children) =>
    Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: List.generate(children.length, (i) => Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(height: 1, thickness: 0.5,
                  indent: 62, color: divCol),
            ],
          )),
        ),
      ),
    );

  Widget _tile(
    BuildContext context, Color card, Color textPri, {
    required String title,
    required IconData leading,
    Color? iconBg,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: iconBg ?? AppColors.primaryMuted,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(leading, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500, color: textPri))),
            trailing ?? Icon(CupertinoIcons.chevron_right,
              color: isDark ? const Color(0xFF48484A) : const Color(0xFFC7C7CC),
              size: 16),
          ]),
        ),
      ),
    );
  }
}
