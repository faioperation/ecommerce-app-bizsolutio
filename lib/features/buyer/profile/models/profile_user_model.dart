class ProfileUserModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int ordersCount;
  final int wishlistCount;
  final int loyaltyPoints;

  ProfileUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.ordersCount = 0,
    this.wishlistCount = 0,
    this.loyaltyPoints = 0,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      ordersCount: json['ordersCount'] ?? 0,
      wishlistCount: json['wishlistCount'] ?? 0,
      loyaltyPoints: json['loyaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatarUrl': avatarUrl,
    'ordersCount': ordersCount,
    'wishlistCount': wishlistCount,
    'loyaltyPoints': loyaltyPoints,
  };
}
