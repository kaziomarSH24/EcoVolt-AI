import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() {
  runApp(
    // ProviderScope is required for Riverpod to work
    const ProviderScope(
      child: EcoVoltApp(),
    ),
  );
}

class EcoVoltApp extends ConsumerWidget {
  const EcoVoltApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider to get the GoRouter instance
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'EcoVolt AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      
      // GoRouter Configuration
      routerConfig: goRouter,
    );
  }
}
