class CartItem {
  final String productId;
  final String title;
  final double price;
  final String imagePath;
  final int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? productId,
    String? title,
    double? price,
    String? imagePath,
    int? quantity,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }
}
