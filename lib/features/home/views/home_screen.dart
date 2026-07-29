import 'package:flutter/material.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/cart/providers/cart_provider.dart';
import 'package:ecovolt_ai/features/cart/models/cart_item.dart';
import 'package:ecovolt_ai/core/widgets/bouncy_button.dart';
import 'package:ecovolt_ai/core/widgets/custom_bottom_nav.dart';
import 'package:ecovolt_ai/features/shop/providers/product_provider.dart';
import 'package:ecovolt_ai/features/shop/providers/category_provider.dart';
import 'package:ecovolt_ai/features/shop/providers/favorite_provider.dart';
import 'package:ecovolt_ai/utils/icon_helper.dart';
import 'package:ecovolt_ai/features/shop/models/product_model.dart';
import 'package:ecovolt_ai/features/shop/models/category_model.dart';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  Widget build(BuildContext context) {
    // Light & Clean Premium UI
    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(rotation: true),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
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
                        _buildHeroSection(context),
                        _buildCategoriesSection(context, ref),
                        const SizedBox(height: 32),
                        _buildPopularProductsSection(context, ref),
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
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(currentIndex: 0, cartKey: cartKey),
          ),
        ],
      ),
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

  Widget _buildHeroSection(BuildContext context) {
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
          const SizedBox(height: 24),
          // ROI Calculator Banner
          GestureDetector(
            onTap: () => context.push('/roi-calculator'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calculate Solar ROI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'See how much you can save.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calculate_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, WidgetRef ref) {
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
        ref.watch(categoryProvider).when(
          data: (categories) {
            if (categories.isEmpty) return const SizedBox.shrink();
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  // 'All' Pill
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () => context.push('/catalog', extra: 'All'),
                      child: const _CategoryPill(
                        icon: Icons.grid_view_rounded,
                        label: 'All',
                        isSelected: false,
                      ),
                    ),
                  ),
                  ...categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () => context.push('/catalog', extra: cat.name),
                        child: _CategoryPill(
                          icon: IconHelper.getIcon(cat.iconName),
                          label: cat.name,
                          isSelected: false,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Text('Error loading categories')),
        ),
      ],
    );
  }

  Widget _buildPopularProductsSection(BuildContext context, WidgetRef ref) {
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
        ref.watch(productProvider).when(
          data: (products) {
            final bestSellers = products.where((p) => p.isBestSeller).toList();
            if (bestSellers.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text('No trending products at the moment.'),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: bestSellers.map((product) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: _PremiumProductCard(
                      title: product.title,
                      subtitle: product.category?.name ?? 'Unknown',
                      price: product.price,
                      imagePath: product.imagePath,
                      tag: 'Best Seller',
                      onAddToCartClick: (key) => runAddToCartAnimation(key),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => const Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Text('Error loading products')),
        ),
      ],
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

  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _PremiumProductCard extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final String price;
  final String imagePath;
  final String? tag;
  final void Function(GlobalKey)? onAddToCartClick;

  const _PremiumProductCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imagePath,
    this.tag,
    this.onAddToCartClick,
  });

  @override
  ConsumerState<_PremiumProductCard> createState() => _PremiumProductCardState();
}

class _PremiumProductCardState extends ConsumerState<_PremiumProductCard> {
  final GlobalKey imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/product-details', extra: {
          'title': widget.title,
          'price': widget.price,
          'imagePath': widget.imagePath,
          'isBestSeller': widget.tag == 'Best Seller',
          'description': ref.read(productProvider).value?.firstWhere((p) => p.title == widget.title).description,
          'features': ref.read(productProvider).value?.firstWhere((p) => p.title == widget.title).features,
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
                  child: Container(
                    key: imageKey,
                    child: Hero(
                      tag: 'catalog_${widget.title}',
                      child: widget.imagePath.startsWith('http')
                          ? Image.network(widget.imagePath, fit: BoxFit.contain)
                          : Image.asset(widget.imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
                if (widget.tag != null)
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
                        widget.tag!,
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
                  child: GestureDetector(
                    onTap: () {
                      final asyncProducts = ref.read(productProvider);
                      final allProducts = asyncProducts.value ?? [];
                      final product = allProducts.firstWhere(
                        (p) => p.title == widget.title,
                        orElse: () => ProductModel(
                          id: widget.title, // Use title as ID so each fallback is unique
                          title: widget.title,
                          category: null,
                          price: widget.price,
                          imagePath: widget.imagePath,
                          isBestSeller: widget.tag == 'Best Seller',
                        ),
                      );
                      ref.read(favoriteProvider.notifier).toggleFavorite(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                        ],
                      ),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final isFavorite = ref.watch(favoriteProvider).value?.any((p) => p.title == widget.title) ?? false;
                          return Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 16,
                            color: isFavorite ? Colors.red : AppColors.textSecondary,
                          );
                        },
                      ),
                    ),
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
                  widget.title,
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
                  widget.subtitle,
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
                      widget.price,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    BouncyButton(
                      onTap: () {
                        widget.onAddToCartClick?.call(imageKey);
                        final product = ref.read(productProvider).value?.firstWhere((p) => p.title == widget.title);
                        ref.read(cartProvider.notifier).addToCart(
                          CartItem(
                            productId: product?.id ?? widget.title,
                            title: widget.title,
                            price: double.tryParse(widget.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0,
                            imagePath: widget.imagePath,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      ),
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
