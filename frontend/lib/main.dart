import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? true;
  themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

  runApp(const ProviderScope(child: ShreeHariApp()));
}

// Exported alias for tests
class ShreeHariAppEntry extends StatelessWidget {
  const ShreeHariAppEntry({super.key});
  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: ShreeHariApp());
  }
}
