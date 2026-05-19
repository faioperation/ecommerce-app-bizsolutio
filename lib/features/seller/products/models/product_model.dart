class SellerProductModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String image;
  final String description;
  final String? video;

  SellerProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.image,
    required this.description,
    this.video,
  });

  bool get isOutOfStock => stock <= 0;

  factory SellerProductModel.fromJson(Map<String, dynamic> json) {
    return SellerProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      video: json['video'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'stock': stock,
      'image': image,
      'description': description,
      'video': video,
    };
  }
}
