class LiveProductModel {
  final String id;
  final int number; // Live identification number (e.g. #1, #2)
  final String title;
  final double price;
  final String imageUrl;
  final bool isCurrentlyFeatured;
  final bool isUpcoming;

  LiveProductModel({
    required this.id,
    required this.number,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.isCurrentlyFeatured = false,
    this.isUpcoming = true,
  });

  factory LiveProductModel.fromJson(Map<String, dynamic> json) {
    return LiveProductModel(
      id: json['id'] as String,
      number: json['number'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isCurrentlyFeatured: json['isCurrentlyFeatured'] as bool? ?? false,
      isUpcoming: json['isUpcoming'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'isCurrentlyFeatured': isCurrentlyFeatured,
      'isUpcoming': isUpcoming,
    };
  }
}
