import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/features/cart/providers/cart_provider.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:ecovolt_ai/features/shop/providers/favorite_provider.dart';

class CustomBottomNav extends ConsumerWidget {
  final int currentIndex;
  final GlobalKey<CartIconKey>? cartKey;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    this.cartKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCartItems = cartItems.fold(0, (sum, item) => sum + item.quantity);
    final totalFavoriteItems = ref.watch(favoriteProvider).value?.length ?? 0;
    final key = cartKey;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            isSelected: currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) context.go('/home');
            },
          ),
          GestureDetector(
            onTap: () => context.push('/cart'),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (key != null)
                  AddToCartIcon(
                    key: key,
                    icon: _NavItem(
                      icon: Icons.shopping_bag_outlined,
                      isSelected: currentIndex == 1,
                    ),
                    badgeOptions: const BadgeOptions(active: false),
                  )
                else
                  _NavItem(
                    icon: Icons.shopping_bag_outlined,
                    isSelected: currentIndex == 1,
                  ),
                if (totalCartItems > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        totalCartItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // AI floating button (middle)
          GestureDetector(
            onTap: () => context.push('/ai-chat'),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex != 2) context.go('/favorites');
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _NavItem(
                  icon: Icons.favorite_border_rounded,
                  isSelected: currentIndex == 2,
                ),
                if (totalFavoriteItems > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        totalFavoriteItems.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            isSelected: currentIndex == 3,
            onTap: () {
              if (currentIndex != 3) context.go('/profile');
            },
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
          size: 28,
        ),
      ),
    );
  }
}
