import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final orderHistoryProvider = FutureProvider<List<OrderModel>>((ref) async {
  final supabase = ref.read(supabaseClientProvider);
  final userId = supabase.auth.currentUser?.id;

  if (userId == null) {
    throw Exception('User is not logged in');
  }

  // Fetch orders, joined with order_items, joined with products
  final response = await supabase
      .from('orders')
      .select('*, order_items(*, products(*))')
      .eq('user_id', userId)
      .order('created_at', ascending: false);

  final List<OrderModel> orders = (response as List)
      .map((json) => OrderModel.fromJson(json))
      .toList();

  return orders;
});
