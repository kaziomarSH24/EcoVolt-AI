import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(CartItem newItem) {
    // Check if item already exists
    final existingIndex = state.indexWhere((item) => item.title == newItem.title);
    
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

  void removeFromCart(String title) {
    state = state.where((item) => item.title != title).toList();
  }
  
  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
