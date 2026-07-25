enum OrderStatus {
  placed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class OrderItem {
  final String title;
  final int quantity;
  final String price;
  final String imagePath;

  OrderItem({
    required this.title,
    required this.quantity,
    required this.price,
    required this.imagePath,
  });
}

class OrderModel {
  final String id;
  final DateTime date;
  final String totalAmount;
  final OrderStatus status;
  final List<OrderItem> items;
  final String shippingAddress;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.items,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  String get formattedDate {
    return "${date.day}/${date.month}/${date.year}";
  }

  String get statusText {
    switch (status) {
      case OrderStatus.placed: return "Order Placed";
      case OrderStatus.processing: return "Processing";
      case OrderStatus.shipped: return "Shipped";
      case OrderStatus.delivered: return "Delivered";
      case OrderStatus.cancelled: return "Cancelled";
    }
  }
}
