import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _nameCtrl   = TextEditingController();
  final _mobileCtrl = TextEditingController();
  final _passCtrl   = TextEditingController();
  String _role      = 'salesman';
  bool   _obscure   = true;
  bool   _loading   = false;

  @override
  void dispose() {
    _nameCtrl.dispose(); _mobileCtrl.dispose(); _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushReplacementNamed(
      context, _role == 'admin' ? '/admin_dashboard' : '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ── Logo ──────────────────────────────────────────────
                // ── Logo ──────────────────────────────────────────────
Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.25),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain, // IMPORTANT for transparent logos
    ),
  ),
),
                const SizedBox(height: 18),

                // ── Brand ─────────────────────────────────────────────
                Text('SHCC', style: AppTextStyles.display.copyWith(
                  color: AppColors.textPrimary, letterSpacing: 2)),
                const SizedBox(height: 6),
                Text('Shree Hari Coal Corporation',
                  style: AppTextStyles.caption, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Sales Order Management',
                    style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                ),
                const SizedBox(height: 40),

                // ── Login card ────────────────────────────────────────
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 440),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                      // Role toggle
                      Text('Sign in as', style: AppTextStyles.caption,
                        textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.bgBase,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(children: [
                          _RoleChip(label: 'Sales Person', value: 'salesman',
                            selected: _role == 'salesman',
                            onTap: () => setState(() => _role = 'salesman')),
                          _RoleChip(label: 'Admin', value: 'admin',
                            selected: _role == 'admin',
                            onTap: () => setState(() => _role = 'admin')),
                        ]),
                      ),
                      const SizedBox(height: 24),

                      // Name
                      TextFormField(
                        controller: _nameCtrl,
                        style: AppTextStyles.body,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Name is required' : null,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline_rounded,
                            size: 18, color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Mobile
                      TextFormField(
                        controller: _mobileCtrl,
                        style: AppTextStyles.body,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Mobile number is required';
                          if (v.length != 10) return 'Enter a valid 10-digit number';
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                          prefixIcon: Icon(Icons.phone_outlined,
                            size: 18, color: AppColors.textMuted),
                          prefixText: '+91  ',
                          prefixStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Password
                      TextFormField(
                        controller: _passCtrl,
                        style: AppTextStyles.body,
                        obscureText: _obscure,
                        validator: (v) => (v == null || v.isEmpty)
                          ? 'Password is required' : null,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                            size: 18, color: AppColors.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                              size: 18, color: AppColors.textMuted),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Submit
SizedBox(
  height: 50,
  child: ElevatedButton(
    onPressed: _loading ? null : _submit,
    child: _loading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Text(
            'Sign In',
            style: AppTextStyles.button,
          ),
  ),
),
                    ]),
                  ),
                ),

                // ✅ FOOTER OUTSIDE GREY BOX
                const SizedBox(height: 36),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Secure Login',
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your data is encrypted and securely stored',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label, value;
  final bool selected;
  final VoidCallback onTap;
  const _RoleChip({
    required this.label, required this.value,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            )),
        ),
      ),
    );
  }
}
