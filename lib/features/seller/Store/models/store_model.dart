class StoreProductModel {
  final String id;
  final String title;
  final double price;
  final String image; // Emoji or asset path

  StoreProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  });

  factory StoreProductModel.fromJson(Map<String, dynamic> json) {
    return StoreProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
    };
  }
}

class StoreModel {
  final String id;
  final String name;
  final String category;
  final String avatar; // Emoji or asset path
  final int followers;
  final double rating;
  final int productsCount;
  final List<StoreProductModel> featuredProducts;

  StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.avatar,
    required this.followers,
    required this.rating,
    required this.productsCount,
    required this.featuredProducts,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      avatar: json['avatar'] as String,
      followers: json['followers'] as int,
      rating: (json['rating'] as num).toDouble(),
      productsCount: json['productsCount'] as int,
      featuredProducts: (json['featuredProducts'] as List<dynamic>?)
              ?.map((item) => StoreProductModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'avatar': avatar,
      'followers': followers,
      'rating': rating,
      'productsCount': productsCount,
      'featuredProducts': featuredProducts.map((p) => p.toJson()).toList(),
    };
  }
}
