import 'package:flutter/material.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/features/auth/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for the animation to finish (1.5s) + a little extra pause (1s) = 2.5s total
    await Future.delayed(const Duration(milliseconds: 2500));
    
    if (!mounted) return;
    
    // Navigate to Login Screen and remove Splash Screen from memory
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeOutBack, // Gives a nice little bounce effect
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Made the image bigger since it contains the text too
                    Image.asset('assets/images/logo.png', height: 200),
                    const SizedBox(height: 32),
                    Text(
                      'Intelligent Power Solutions',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onPrimary.withValues(alpha: 0.8),
                        letterSpacing:
                            1.5, // Added some spacing between letters for a premium look
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
