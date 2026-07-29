class ProfileModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String? address;
  final double impactScore;

  ProfileModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.address,
    this.impactScore = 0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      address: json['address'],
      impactScore: (json['impact_score'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'address': address,
      'impact_score': impactScore,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? phone,
    String? address,
    double? impactScore,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      impactScore: impactScore ?? this.impactScore,
    );
  }
}
