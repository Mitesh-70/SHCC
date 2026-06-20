import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/port_admin/screens/port_admin_dashboard_screen.dart';

// ── Global theme notifier ─────────────────────────────────────────────────────
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

class ShreeHariApp extends StatelessWidget {
  const ShreeHariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) => MaterialApp(
        title: 'SHCC Sales',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mode,
        initialRoute: '/login',
        routes: {
          '/login':               (_) => const LoginScreen(),
          '/dashboard':           (_) => const DashboardScreen(),
          '/admin_dashboard':     (_) => const AdminDashboardScreen(),
          '/port_admin_dashboard':(_) => const PortAdminDashboardScreen(),
        },
      ),
    );
  }
}
