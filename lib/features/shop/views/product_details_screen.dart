import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:ecovolt_ai/features/cart/providers/cart_provider.dart';
import 'package:ecovolt_ai/features/cart/models/cart_item.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  late Future<void> Function(GlobalKey) runAddToCartAnimation;
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: AppColors.surface, // Light background for the top
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 24,
                      right: 24,
                      bottom: 120,
                    ), // Extra bottom padding for fixed bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildSpecifications(
                          widget.product['features'] as List<String>?,
                        ),
                        const SizedBox(height: 32),
                        _buildDescription(
                          widget.product['description'] as String?,
                        ),
                        const SizedBox(height: 32),
                        _buildReviews(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalCartItems = cartItems.fold(
      0,
      (sum, item) => sum + item.quantity,
    );

    return SliverAppBar(
      expandedHeight: 350.0,
      backgroundColor: AppColors.surface,
      elevation: 0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => context.push('/cart'),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AddToCartIcon(
                    key: cartKey,
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.textPrimary,
                    ),
                    badgeOptions: const BadgeOptions(
                      active: false,
                    ), // Use Riverpod badge instead
                  ),
                  if (totalCartItems > 0)
                    Positioned(
                      right: 4,
                      top: 4,
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
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: Hero(
                tag: 'catalog_${widget.product['title']}',
                child: Container(
                  key: _imageKey,
                  child: widget.product['imagePath'].startsWith('http')
                      ? Image.network(
                          widget.product['imagePath'],
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          widget.product['imagePath'],
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.product['isBestSeller'] == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Best Seller',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        Text(
          widget.product['title'],
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 4),
            const Text(
              '4.9',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              '(124 reviews)',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecifications(List<String>? features) {
    if (features == null || features.isEmpty) {
      return const SizedBox.shrink(); // Hide if no features
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: _SpecItem(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Feature',
                  value: feature,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Text('👨‍💼', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ariful Islam',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  '"Best investment for my home! Highly recommended."',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onAddToCartClick(GlobalKey widgetKey) async {
    // 1. Trigger Animation
    await runAddToCartAnimation(widgetKey);

    // 2. Add to Provider State
    final priceString = widget.product['price'].toString();
    final parsedPrice =
        double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    ref
        .read(cartProvider.notifier)
        .addToCart(
          CartItem(
            productId: widget.product['id'],
            title: widget.product['title'],
            price: parsedPrice,
            imagePath: widget.product['imagePath'],
          ),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added to cart'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    widget.product['price'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _onAddToCartClick(_imageKey),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 84),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
