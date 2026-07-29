import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecovolt_ai/features/orders/models/order_model.dart';

class OrderNotifier extends Notifier<List<OrderModel>> {
  @override
  List<OrderModel> build() {
    // Provide some dummy orders
    return [
      OrderModel(
        id: "ORD-92847",
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalAmount: "৳1,250.00",
        status: OrderStatus.processing,
        shippingAddress: "House 12, Road 5, Dhanmondi, Dhaka",
        paymentMethod: "Visa ending in 4242",
        items: [
          OrderItem(
            title: "EcoVolt 1KW Solar Panel",
            quantity: 2,
            price: "৳500.00",
            imagePath: "assets/images/ev3.png",
          ),
          OrderItem(
            title: "Smart Solar Inverter 2KVA",
            quantity: 1,
            price: "৳250.00",
            imagePath: "assets/images/ev2.png",
          ),
        ],
      ),
      OrderModel(
        id: "ORD-83921",
        date: DateTime.now().subtract(const Duration(days: 14)),
        totalAmount: "৳120.00",
        status: OrderStatus.delivered,
        shippingAddress: "House 12, Road 5, Dhanmondi, Dhaka",
        paymentMethod: "Cash on Delivery",
        items: [
          OrderItem(
            title: "EcoVolt 600VA Smart IPS",
            quantity: 1,
            price: "৳120.00",
            imagePath: "assets/images/ev1.png",
          ),
        ],
      ),
    ];
  }
}

final orderProvider = NotifierProvider<OrderNotifier, List<OrderModel>>(() {
  return OrderNotifier();
});
