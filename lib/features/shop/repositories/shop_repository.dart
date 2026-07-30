import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecovolt_ai/features/shop/models/product_model.dart';
import 'package:ecovolt_ai/features/shop/models/category_model.dart';

class ShopRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _supabase.from('products').select('*, categories(*)');
      
      // Parse the JSON data into a list of ProductModel
      return (response as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _supabase.from('categories').select();
      
      // Parse the JSON data into a list of CategoryModel
      return (response as List<dynamic>)
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}

// Provider for ShopRepository
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});
