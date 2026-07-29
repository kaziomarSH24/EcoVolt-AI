class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String status;
  final String address;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.address,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = <OrderItemModel>[];
    if (json['order_items'] != null) {
      itemsList = (json['order_items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList();
    }
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      address: json['address'],
      createdAt: DateTime.parse(json['created_at']),
      items: itemsList,
    );
  }
}

class OrderItemModel {
  final String id;
  final String productId;
  final int quantity;
  final double priceAtTime;
  final Map<String, dynamic>? product; // To store joined product data

  OrderItemModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.priceAtTime,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      priceAtTime: (json['price_at_purchase'] as num).toDouble(),
      product: json['products'], // Supabase joins relationship name is often the table name
    );
  }
}
