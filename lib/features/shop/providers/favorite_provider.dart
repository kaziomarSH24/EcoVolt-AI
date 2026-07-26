import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/shop/providers/product_provider.dart';

class FavoriteNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [];
  }

  void toggleFavorite(ProductModel product) {
    final isFavorite = state.any((p) => p.id == product.id);
    if (isFavorite) {
      state = state.where((p) => p.id != product.id).toList();
    } else {
      state = [...state, product];
    }
  }

  bool isFavorite(String productId) {
    return state.any((p) => p.id == productId);
  }
}

final favoriteProvider = NotifierProvider<FavoriteNotifier, List<ProductModel>>(() {
  return FavoriteNotifier();
});
