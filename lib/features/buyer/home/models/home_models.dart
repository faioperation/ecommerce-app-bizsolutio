class StoryModel {
  final String id;
  final String sellerName;
  final String profileImage;
  final bool isLive;

  StoryModel({
    required this.id,
    required this.sellerName,
    required this.profileImage,
    this.isLive = false,
  });
}

enum FeedType { post, live }

class FeedItemModel {
  final String id;
  final String sellerName;
  final String title;
  final double price;
  final String imageUrl;
  final FeedType type;
  final int likes;
  final int comments;
  final bool isLiked;

  FeedItemModel({
    required this.id,
    required this.sellerName,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.type,
    this.likes = 0,
    this.comments = 0,
    this.isLiked = false,
  });
}
