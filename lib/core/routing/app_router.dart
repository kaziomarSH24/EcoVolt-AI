import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import your existing screens
import '../../features/auth/views/splash_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/signup_screen.dart';
import '../../features/home/views/home_screen.dart';
import 'package:ecovolt_ai/features/shop/views/product_catalog_screen.dart';
import 'package:ecovolt_ai/features/shop/views/categories_screen.dart';
import 'package:ecovolt_ai/features/shop/views/product_details_screen.dart';
import 'package:ecovolt_ai/features/checkout/views/checkout_screen.dart';
import 'package:ecovolt_ai/features/cart/views/cart_screen.dart';
import 'package:ecovolt_ai/features/profile/views/profile_screen.dart';
import 'package:ecovolt_ai/features/profile/views/edit_profile_screen.dart';
import 'package:ecovolt_ai/features/ai_consultant/views/ai_chat_screen.dart';
import 'package:ecovolt_ai/features/orders/views/order_history_screen.dart';
import 'package:ecovolt_ai/features/orders/views/order_tracking_screen.dart';
import 'package:ecovolt_ai/features/orders/models/order_model.dart';
import 'package:ecovolt_ai/features/calculator/views/roi_calculator_screen.dart';
import 'package:ecovolt_ai/features/shop/views/favorite_screen.dart';
import 'package:ecovolt_ai/features/auth/providers/auth_provider.dart';
import 'package:ecovolt_ai/features/auth/views/otp_verify_screen.dart';

// Create a notifier that triggers when auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, _) => notifyListeners());
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';
      final isOtpVerifying = state.matchedLocation == '/otp-verify';

      if (!isLoggedIn && !isLoggingIn && !isOtpVerifying && state.matchedLocation != '/') {
        return '/login';
      }
      if (isLoggedIn && (isLoggingIn || isOtpVerifying)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/otp-verify',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OtpVerifyScreen(email: email);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/catalog',
        builder: (context, state) {
          final categoryName = state.extra as String?;
          return ProductCatalogScreen(categoryName: categoryName ?? 'All');
        },
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as Map<String, dynamic>;
          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) {
          final sessionId = state.uri.queryParameters['session_id'];
          return CheckoutScreen(sessionId: sessionId);
        },
      ),
      GoRoute(
        path: '/payment-cancel',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AiChatScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/order-tracking',
        builder: (context, state) {
          final order = state.extra as OrderModel;
          return OrderTrackingScreen(order: order);
        },
      ),
      GoRoute(
        path: '/roi-calculator',
        builder: (context, state) => const RoiCalculatorScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoriteScreen(),
      ),
    ],
  );
});

// A temporary placeholder screen for screens not built yet
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
    );
  }
}
