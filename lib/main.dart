import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/splash_screen.dart';

void main() {
  runApp(const EcoVoltApp());
}

class EcoVoltApp extends StatelessWidget {
  const EcoVoltApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoVolt AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
