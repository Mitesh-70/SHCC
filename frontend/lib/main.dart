import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
