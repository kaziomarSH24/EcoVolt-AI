import 'package:ecovolt_ai/features/shop/models/category_model.dart';

class ProductModel {
  final String id;
  final String title;
  final CategoryModel? category;
  final String price;
  final String imagePath;
  final bool isBestSeller;
  final String? description;
  final List<String>? features;

  ProductModel({
    required this.id,
    required this.title,
    this.category,
    required this.price,
    required this.imagePath,
    this.isBestSeller = false,
    this.description,
    this.features,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // We get numeric price from DB, so we format it back to String with $ sign.
    final num priceVal = json['price'] as num;
    final formattedPrice = '৳${priceVal.toStringAsFixed(2)}';

    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['categories'] != null ? CategoryModel.fromJson(json['categories'] as Map<String, dynamic>) : null,
      price: formattedPrice,
      imagePath: json['imagePath'] ?? json['image_path'] as String,
      isBestSeller: json['isBestSeller'] ?? json['is_best_seller'] as bool? ?? false,
      description: json['description'] as String?,
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    );
  }
}
