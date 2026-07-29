import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecovolt_ai/features/shop/models/product_model.dart';
import 'package:ecovolt_ai/features/shop/providers/product_provider.dart';
import 'package:ecovolt_ai/features/shop/repositories/favorite_repository.dart';

class FavoriteNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() async {
    return _fetchFavorites();
  }

  Future<List<ProductModel>> _fetchFavorites() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    final repository = ref.read(favoriteRepositoryProvider);
    final favoriteIds = await repository.getFavoriteProductIds(user.id);
    
    // We need to get the actual product objects from the productProvider
    // Wait for products to load if they haven't
    final products = await ref.watch(productProvider.future);
    
    return products.where((p) => favoriteIds.contains(p.id)).toList();
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final repository = ref.read(favoriteRepositoryProvider);
    final currentFavorites = state.value ?? [];
    
    final isFavorite = currentFavorites.any((p) => p.id == product.id);
    
    // Optimistic update
    if (isFavorite) {
      state = AsyncValue.data(currentFavorites.where((p) => p.id != product.id).toList());
    } else {
      state = AsyncValue.data([...currentFavorites, product]);
    }

    try {
      if (isFavorite) {
        await repository.removeFavorite(user.id, product.id);
      } else {
        await repository.addFavorite(user.id, product.id);
      }
    } catch (e) {
      // Revert on failure
      state = AsyncValue.data(currentFavorites);
      rethrow;
    }
  }

  bool isFavorite(String productId) {
    return state.value?.any((p) => p.id == productId) ?? false;
  }
}

final favoriteProvider = AsyncNotifierProvider<FavoriteNotifier, List<ProductModel>>(() {
  return FavoriteNotifier();
});
