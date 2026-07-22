import 'package:flutter/material.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/cart/providers/cart_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Light & Clean Premium UI
    return Scaffold(
      backgroundColor: Colors.white, // Very clean white background
      body: Stack(
        children: [
          // Background subtle shapes/accents if any
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.03),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(),
                        _buildCategoriesSection(context),
                        const SizedBox(height: 32),
                        _buildPopularProductsSection(),
                        const SizedBox(height: 120), // padding for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Custom Bottom Navigation Bar Floating
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildFloatingBottomNav(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo or Name
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('assets/images/sort_logo.png', fit: BoxFit.contain),
              ),
              const SizedBox(width: 12),
              const Text(
                'EcoVolt',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Notification Profile
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surface,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text(
            'Powering\nYour Future.',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Smart, sustainable energy solutions for a brighter tomorrow.',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          // Floating Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search panels, inverters...',
                      hintStyle: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5), fontSize: 15),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/categories'),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              _CategoryPill(icon: Icons.solar_power_rounded, label: 'Solar', isSelected: true),
              const SizedBox(width: 12),
              _CategoryPill(icon: Icons.battery_charging_full_rounded, label: 'Batteries'),
              const SizedBox(width: 12),
              _CategoryPill(icon: Icons.power_rounded, label: 'Inverters'),
              const SizedBox(width: 12),
              _CategoryPill(icon: Icons.wind_power_rounded, label: 'Wind'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Trending Now',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              _PremiumProductCard(
                title: '5kW Mono-PERC Panel',
                subtitle: 'High Efficiency',
                price: '\$1,200',
                imagePath: 'assets/images/ev1.png',
                tag: 'Best Seller',
              ),
              const SizedBox(width: 16),
              _PremiumProductCard(
                title: '200Ah Lithium Pack',
                subtitle: 'Deep Cycle',
                price: '\$450',
                imagePath: 'assets/images/ev2.png',
              ),
              const SizedBox(width: 16),
              _PremiumProductCard(
                title: '3kVA Smart IPS',
                subtitle: 'Pure Sine Wave',
                price: '\$300',
                imagePath: 'assets/images/ev3.png',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingBottomNav(WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final totalCartItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

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
          const _NavItem(icon: Icons.home_rounded, isSelected: true),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const _NavItem(icon: Icons.shopping_bag_outlined),
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
          // AI floating button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24),
          ),
          _NavItem(icon: Icons.favorite_border_rounded),
          _NavItem(icon: Icons.person_outline_rounded),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _CategoryPill({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/catalog'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.black.withValues(alpha: 0.05),
        ),
        boxShadow: isSelected ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ] : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _PremiumProductCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String imagePath;
  final String? tag;

  const _PremiumProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details', extra: {
          'title': title,
          'price': price,
          'imagePath': imagePath,
          'isBestSeller': tag == 'Best Seller',
        });
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Container(
            height: 180,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface, // Very light background
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Hero(
                    tag: 'catalog_$title',
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                ),
                if (tag != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 16, color: AppColors.textSecondary),
                  ),
                )
              ],
            ),
          ),
          // Details Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const _NavItem({required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
      size: 28,
    );
  }
}
