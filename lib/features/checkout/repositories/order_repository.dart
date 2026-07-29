import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:ecovolt_ai/features/cart/models/cart_item.dart';

class OrderRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Get Stripe Secret Key from .env file
  // Warning: In a real production app, NEVER put the secret key in the app code!
  String get _stripeSecretKey => dotenv.env['STRIPE_SECRET_KEY'] ?? ''; 

  Future<String> createOrderAndPaymentSession({
    required List<CartItem> cartItems,
    required double totalAmount,
    required String address,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // 1. Create Order in Supabase
    final orderResponse = await _supabase.from('orders').insert({
      'user_id': user.id,
      'total_amount': totalAmount,
      'status': 'pending',
      'address': address,
    }).select().single();
    
    final orderId = orderResponse['id'];

    // 2. Create Order Items
    final orderItemsData = cartItems.map((item) => {
      'order_id': orderId,
      'product_id': item.productId,
      'quantity': item.quantity,
      'price_at_purchase': item.price,
    }).toList();
    
    await _supabase.from('order_items').insert(orderItemsData);

    // 3. Create Stripe Checkout Session
    final stripeResponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/checkout/sessions'),
      headers: {
        'Authorization': 'Bearer $_stripeSecretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'success_url': 'https://nxyxxqfhcwfshxcquokw.supabase.co/functions/v1/payment-redirect?type=success&session_id={CHECKOUT_SESSION_ID}',
        'cancel_url': 'https://nxyxxqfhcwfshxcquokw.supabase.co/functions/v1/payment-redirect?type=cancel',
        'mode': 'payment',
        'line_items[0][price_data][currency]': 'bdt', 
        'line_items[0][price_data][product_data][name]': 'EcoVolt Order',
        'line_items[0][price_data][unit_amount]': (totalAmount * 100).toInt().toString(), // Amount in cents
        'line_items[0][quantity]': '1',
      },
    );

    if (stripeResponse.statusCode == 200) {
      final responseData = json.decode(stripeResponse.body);
      final sessionId = responseData['id'];
      final checkoutUrl = responseData['url'];

      // 4. Save Transaction in Supabase
      await _supabase.from('transactions').insert({
        'user_id': user.id,
        'order_id': orderId,
        'stripe_session_id': sessionId,
        'amount': totalAmount,
        'status': 'pending',
      });

      return checkoutUrl;
    } else {
      throw Exception('Failed to create Stripe session: ${stripeResponse.body}');
    }
  }

  Future<void> confirmPayment(String sessionId) async {
    // 1. Update Transaction
    final transactionResponse = await _supabase
        .from('transactions')
        .update({'status': 'completed'})
        .eq('stripe_session_id', sessionId)
        .select()
        .single();
        
    final orderId = transactionResponse['order_id'];

    // 2. Update Order
    await _supabase
        .from('orders')
        .update({'status': 'paid'})
        .eq('id', orderId);
  }
  
  Future<void> cancelPayment(String sessionId) async {
    await _supabase
        .from('transactions')
        .update({'status': 'failed'})
        .eq('stripe_session_id', sessionId);
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});
