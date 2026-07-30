import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<String>> getFavoriteProductIds(String userId) async {
    final response = await _supabase
        .from('favorites')
        .select('product_id')
        .eq('user_id', userId);
    
    return (response as List).map((e) => e['product_id'] as String).toList();
  }

  Future<void> addFavorite(String userId, String productId) async {
    await _supabase.from('favorites').insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<void> removeFavorite(String userId, String productId) async {
    await _supabase
        .from('favorites')
        .delete()
        .match({
          'user_id': userId,
          'product_id': productId,
        });
  }
}

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository();
});
