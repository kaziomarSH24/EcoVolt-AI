import 'package:flutter/material.dart';
import 'package:ecovolt_ai/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/shop/providers/category_provider.dart';
import 'package:ecovolt_ai/utils/icon_helper.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'All Categories',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ref.watch(categoryProvider).when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildCategoryCard(
                  context: context,
                  title: 'All',
                  iconName: 'category', // Will fallback to Icons.category
                  imageUrl: null,
                  colorHex: '#F3F4F6', // Light gray
                  iconColorHex: '#424242', // Dark gray
                );
              }
              final cat = categories[index - 1];
              return _buildCategoryCard(
                context: context,
                title: cat.name,
                iconName: cat.iconName,
                imageUrl: cat.imageUrl,
                colorHex: cat.bgColorHex,
                iconColorHex: cat.iconColorHex,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    String? iconName,
    String? imageUrl,
    String? colorHex,
    String? iconColorHex,
  }) {
    final bgColor = IconHelper.getColorFromHex(colorHex, fallback: const Color(0xFFE8F5E9));
    final iconColor = IconHelper.getColorFromHex(iconColorHex, fallback: Colors.green);

    return GestureDetector(
      onTap: () => context.push('/products', extra: title),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: bgColor.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.contain)
                  : Icon(IconHelper.getIcon(iconName), size: 40, color: iconColor),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'View items', // Or compute item count if desired
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
