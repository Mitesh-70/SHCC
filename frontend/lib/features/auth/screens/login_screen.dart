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
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _mobileCtrl  = TextEditingController();
  final _passCtrl    = TextEditingController();
  String _role       = 'salesman';
  bool   _obscure    = true;
  bool   _loading    = false;

  // ── Always dark palette ───────────────────────────────────────────
  static const _bg       = Color(0xFF0A0A0A);
  static const _surface  = Color(0xFF141414);
  static const _card     = Color(0xFF1C1C1C);
  static const _input    = Color(0xFF1C1C1C);
  static const _border   = Color(0xFF2A2A2A);
  static const _txtPrim  = Color(0xFFF2F2F2);
  static const _txtSec   = Color(0xFF9A9A9A);
  static const _txtMuted = Color(0xFF555555);

  @override
  void initState() {
    super.initState();
    // Force dark status bar regardless of app theme
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

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
    return Theme(
      // Wrap in a forced dark theme so this screen is ALWAYS dark
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        primaryColor: AppColors.primary,
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: _input,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primary, width: 1.5)),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error)),
          labelStyle: const TextStyle(color: _txtSec, fontSize: 12),
          hintStyle: const TextStyle(color: _txtMuted, fontSize: 13),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
            textStyle: AppTextStyles.button)),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: _txtPrim),
          bodySmall:  TextStyle(color: _txtSec),
        ),
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Logo
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 24, offset: const Offset(0, 8))]),
                    child: const Icon(Icons.local_fire_department_rounded,
                      color: Colors.white, size: 36)),
                  const SizedBox(height: 20),

                  // Brand
                  const Text('SHCC',
                    style: TextStyle(
                      color: _txtPrim, fontSize: 28,
                      fontWeight: FontWeight.w800, letterSpacing: 2)),
                  const SizedBox(height: 6),
                  const Text('Shree Hari Coal Corporation',
                    style: TextStyle(color: _txtSec, fontSize: 13),
                    textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryMuted,
                      borderRadius: BorderRadius.circular(20)),
                    child: const Text('Sales Order Management',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12, fontWeight: FontWeight.w500))),
                  const SizedBox(height: 40),

                  // Login card
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 440),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _border)),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          // Role toggle
                          const Text('Sign in as',
                            style: TextStyle(
                              color: _txtSec, fontSize: 12),
                            textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _border)),
                            child: Row(children: [
                              _RoleTab(
                                label: 'Sales Person',
                                selected: _role == 'salesman',
                                onTap: () => setState(
                                  () => _role = 'salesman')),
                              _RoleTab(
                                label: 'Admin',
                                selected: _role == 'admin',
                                onTap: () => setState(
                                  () => _role = 'admin')),
                            ])),
                          const SizedBox(height: 24),

                          // Name
                          TextFormField(
                            controller: _nameCtrl,
                            style: const TextStyle(color: _txtPrim),
                            textCapitalization: TextCapitalization.words,
                            validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Name is required' : null,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person_outline_rounded,
                                size: 18, color: _txtMuted))),
                          const SizedBox(height: 14),

                          // Mobile
                          TextFormField(
                            controller: _mobileCtrl,
                            style: const TextStyle(color: _txtPrim),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)],
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Mobile number is required';
                              }
                              if (v.length != 10) {
                                return 'Enter a valid 10-digit number';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Mobile Number',
                              prefixIcon: Icon(Icons.phone_outlined,
                                size: 18, color: _txtMuted),
                              prefixText: '+91  ',
                              prefixStyle: TextStyle(
                                color: _txtSec, fontSize: 14))),
                          const SizedBox(height: 14),

                          // Password
                          TextFormField(
                            controller: _passCtrl,
                            style: const TextStyle(color: _txtPrim),
                            obscureText: _obscure,
                            validator: (v) => (v == null || v.isEmpty)
                              ? 'Password is required' : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded,
                                size: 18, color: _txtMuted),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                  size: 18, color: _txtMuted),
                                onPressed: () => setState(
                                  () => _obscure = !_obscure)))),
                          const SizedBox(height: 28),

                          // Submit
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                ? const SizedBox(
                                    width: 22, height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white))
                                : const Text('Sign In',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RoleTab({
    required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9)),
        child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? Colors.white : const Color(0xFF9A9A9A)))),
    ));
}
