class AddressModel {
  final String id;
  final String userId;
  final String title;
  final String addressLine;
  final String city;
  final String zipCode;
  final String phone;
  final bool isDefault;
  final DateTime createdAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.addressLine,
    required this.city,
    required this.zipCode,
    required this.phone,
    required this.isDefault,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      addressLine: json['address_line'] as String,
      city: json['city'] as String,
      zipCode: json['zip_code'] as String,
      phone: json['phone'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'title': title,
      'address_line': addressLine,
      'city': city,
      'zip_code': zipCode,
      'phone': phone,
      'is_default': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? addressLine,
    String? city,
    String? zipCode,
    String? phone,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
