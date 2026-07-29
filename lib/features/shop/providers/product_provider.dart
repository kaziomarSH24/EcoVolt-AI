import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/shop/repositories/shop_repository.dart';
import 'package:ecovolt_ai/features/shop/models/product_model.dart';

class ProductNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  Future<List<ProductModel>> build() async {
    return ref.watch(shopRepositoryProvider).getProducts();
  }
}

final productProvider = AsyncNotifierProvider<ProductNotifier, List<ProductModel>>(() {
  return ProductNotifier();
});

