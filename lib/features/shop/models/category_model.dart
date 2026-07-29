class CategoryModel {
  final String id;
  final String name;
  final String? iconName;
  final String? imageUrl;
  final String? iconColorHex;
  final String? bgColorHex;

  CategoryModel({
    required this.id,
    required this.name,
    this.iconName,
    this.imageUrl,
    this.iconColorHex,
    this.bgColorHex,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String?,
      imageUrl: json['image_url'] as String?,
      iconColorHex: json['icon_color_hex'] as String?,
      bgColorHex: json['bg_color_hex'] as String?,
    );
  }
}
