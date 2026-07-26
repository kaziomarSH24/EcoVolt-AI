import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductModel {
  final String id;
  final String title;
  final String category;
  final String price;
  final String imagePath;
  final bool isBestSeller;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.imagePath,
    this.isBestSeller = false,
  });
}

class ProductNotifier extends Notifier<List<ProductModel>> {
  @override
  List<ProductModel> build() {
    return [
      ProductModel(
        id: 'p1',
        title: 'EcoVolt 1KW Solar Panel',
        category: 'Solar',
        price: '\$500.00',
        imagePath: 'assets/images/ev3.png',
        isBestSeller: true,
      ),
      ProductModel(
        id: 'p2',
        title: 'Smart Solar Inverter 2KVA',
        category: 'Inverters',
        price: '\$250.00',
        imagePath: 'assets/images/ev2.png',
      ),
      ProductModel(
        id: 'p3',
        title: 'EcoVolt 600VA Smart IPS',
        category: 'Inverters',
        price: '\$120.00',
        imagePath: 'assets/images/ev1.png',
        isBestSeller: true,
      ),
      ProductModel(
        id: 'p4',
        title: 'Lithium Ion Battery 100Ah',
        category: 'Batteries',
        price: '\$350.00',
        imagePath: 'assets/images/ev2.png',
      ),
      ProductModel(
        id: 'p5',
        title: 'Tubular Battery 200Ah',
        category: 'Batteries',
        price: '\$220.00',
        imagePath: 'assets/images/ev1.png',
      ),
      ProductModel(
        id: 'p6',
        title: 'Hybrid Solar Controller',
        category: 'Accessories',
        price: '\$80.00',
        imagePath: 'assets/images/ev3.png',
      ),
    ];
  }
}

final productProvider = NotifierProvider<ProductNotifier, List<ProductModel>>(() {
  return ProductNotifier();
});
