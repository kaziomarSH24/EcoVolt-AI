import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/shop/repositories/shop_repository.dart';
import 'package:ecovolt_ai/features/shop/models/category_model.dart';

class CategoryNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    return ref.watch(shopRepositoryProvider).getCategories();
  }
}

final categoryProvider = AsyncNotifierProvider<CategoryNotifier, List<CategoryModel>>(() {
  return CategoryNotifier();
});
