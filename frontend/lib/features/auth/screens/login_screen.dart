import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _authError;

  // ── Always dark palette ───────────────────────────────────────────
  static const _bg = Color(0xFF0A0A0A);
  static const _card = Color(0xFF1C1C1C);
  static const _input = Color(0xFF1C1C1C);
  static const _border = Color(0xFF2A2A2A);
  static const _txtPrim = Color(0xFFF2F2F2);
  static const _txtSec = Color(0xFF9A9A9A);
  static const _txtMuted = Color(0xFF555555);

  @override
  void initState() {
    super.initState();
    // Force dark status bar regardless of app theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    final username = _emailCtrl.text.trim().toLowerCase();
    final password = _passCtrl.text;

    String? route;
    String? customError;

    if (username == 'salesperson' && password == 'sales123') {
      AppSession.setSalesPerson(name: 'Raj Sharma', id: 'sp-001');
      route = '/dashboard';
    } else if (username == 'admin' && password == 'admin123') {
      AppSession.setAdmin(name: 'Admin', id: 'admin-001');
      route = '/admin_dashboard';
    } else {
      final pa = PortAdminStore.findByUsername(username);
      if (pa != null && password == 'port123') {
        if (!pa.isActive) {
          customError = 'This account has been deactivated.';
        } else {
          AppSession.setPortAdmin(
            name: pa.name,
            id: pa.id,
            assignedPorts: pa.assignedPorts,
          );
          route = '/port_admin_dashboard';
        }
      }
    }

    if (customError != null) {
      setState(() {
        _loading = false;
        _authError = customError;
      });
      return;
    }

    if (route == null) {
      setState(() {
        _loading = false;
        _authError = 'Invalid username or password';
      });
      return;
    }

    setState(() => _loading = false);
    Navigator.pushReplacementNamed(context, route);
  }

  String? _validateEmail(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Username is required';
    if (username.contains('@')) return 'Enter username only';
    final valid = RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(username);
    if (!valid) return 'Use letters, numbers, dot, hyphen or underscore';
    return null;
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
          filled: true,
          fillColor: _input,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
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
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: AppTextStyles.button,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: _txtPrim),
          bodySmall: TextStyle(color: _txtSec),
        ),
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Transform.translate(
                offset: const Offset(0, -28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
  width: 120,
  height: 120,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.35),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: ClipOval(
    child: Image.asset(
      'assets/images/logo.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    ),
  ),
),
const SizedBox(height: 20),

                    // Brand
                    const Text(
                      'SHCC',
                      style: TextStyle(
                        color: _txtPrim,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Shree Hari Coal Corporation',
                      style: TextStyle(
                        color: _txtSec,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 34),

                    // Login card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 440),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _border),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Sign in to continue',
                              style: TextStyle(color: _txtSec, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Email
                            const Text(
                              'Email',
                              style: TextStyle(
                                color: Color(0xFFD6BDAE),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                            ),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: _emailCtrl,
                              style: const TextStyle(
                                color: _txtPrim,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              enableSuggestions: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9._-]'),
                                ),
                              ],
                              validator: _validateEmail,
                              onChanged: (_) {
                                if (_authError != null) {
                                  setState(() => _authError = null);
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: null,
                                hintText: 'salesperson',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF8C817D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF2B2B2D),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFB477),
                                    width: 1.2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  size: 21,
                                  color: Color(0xFF9A8176),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 46,
                                  minHeight: 46,
                                ),
                                suffixText: '@shcc.co.in',
                                suffixStyle: const TextStyle(
                                  color: Color(0xFFFFB477),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color(0xFFD6BDAE),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFFFFB477),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    'Forgot?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 9),
                            TextFormField(
                              controller: _passCtrl,
                              style: const TextStyle(
                                color: _txtPrim,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                              ),
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                  _loading ? null : _submit(),
                              onChanged: (_) {
                                if (_authError != null) {
                                  setState(() => _authError = null);
                                }
                              },
                              validator: (v) => (v == null || v.isEmpty)
                                  ? 'Password is required'
                                  : null,
                              decoration: InputDecoration(
                                isDense: true,
                                labelText: null,
                                hintText: '••••••••',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF8C817D),
                                  fontSize: 16,
                                  letterSpacing: 2.4,
                                ),
                                filled: true,
                                fillColor: const Color(0xFF2B2B2D),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFFFB477),
                                    width: 1.2,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.2,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: AppColors.error,
                                    width: 1.2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  size: 21,
                                  color: Color(0xFF9A8176),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 46,
                                  minHeight: 46,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 21,
                                    color: const Color(0xFF9A8176),
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                                suffixIconConstraints: const BoxConstraints(
                                  minWidth: 46,
                                  minHeight: 46,
                                ),
                              ),
                            ),
                            if (_authError != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.errorMuted,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.error.withValues(
                                      alpha: 0.35,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline_rounded,
                                      color: AppColors.error,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _authError!,
                                        style: const TextStyle(
                                          color: AppColors.error,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),

                            // Submit
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFB477),
                                  foregroundColor: const Color(0xFF3A2418),
                                  disabledBackgroundColor: const Color(
                                    0xFFFFB477,
                                  ).withValues(alpha: 0.58),
                                  elevation: 0,
                                  shadowColor: const Color(
                                    0xFFFFB477,
                                  ).withValues(alpha: 0.35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
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
                                    : const Text(
                                        'Sign In',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF3A2418),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 44),
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: 'Trouble logging in? ',
                                  style: const TextStyle(
                                    color: Color(0xFF8D7E79),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Contact Admin',
                                      style: const TextStyle(
                                        color: Color(0xFFFFB477),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
      ),
    );
  }
}