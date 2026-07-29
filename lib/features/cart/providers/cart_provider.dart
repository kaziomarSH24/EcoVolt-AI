import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(CartItem newItem) {
    // Check if item already exists
    final existingIndex = state.indexWhere((item) => item.productId == newItem.productId);
    
    if (existingIndex >= 0) {
      // Increase quantity
      final existingItem = state[existingIndex];
      final updatedList = List<CartItem>.from(state);
      updatedList[existingIndex] = existingItem.copyWith(quantity: existingItem.quantity + 1);
      state = updatedList;
    } else {
      // Add new item
      state = [...state, newItem];
    }
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final existingIndex = state.indexWhere((item) => item.productId == productId);
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final updatedList = List<CartItem>.from(state);
      updatedList[existingIndex] = existingItem.copyWith(quantity: newQuantity);
      state = updatedList;
    }
  }

  void removeFromCart(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }
  
  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return state.fold(0.0, (sum, item) {
      return sum + (item.price * item.quantity);
    });
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
