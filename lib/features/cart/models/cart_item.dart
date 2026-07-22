class CartItem {
  final String title;
  final String price;
  final String imagePath;
  final int quantity;

  CartItem({
    required this.title,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? title,
    String? price,
    String? imagePath,
    int? quantity,
  }) {
    return CartItem(
      title: title ?? this.title,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
    );
  }
}
