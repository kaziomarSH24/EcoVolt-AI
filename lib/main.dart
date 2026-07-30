import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    publishableKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Configure window size for desktop platforms (macOS, Windows, Linux)
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(450, 800),
      minimumSize: Size(450, 800),
      maximumSize: Size(450, 800),
      center: true,
      title: 'EcoVolt AI',
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      // Lock window resizing
      await windowManager.setResizable(false);
      await windowManager.setMaximizable(false);
    });
  }

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
      
      // Allow mouse drag scrolling on desktop/web
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
        },
      ),

      // GoRouter Configuration
      routerConfig: goRouter,
    );
  }
}
