import 'package:get/get.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  final RxList<StoryModel> stories = <StoryModel>[].obs;
  final RxList<FeedItemModel> feedItems = <FeedItemModel>[].obs;
  final RxMap<String, RxList<CommentModel>> commentsMap = <String, RxList<CommentModel>>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;

    stories.assignAll([
      StoryModel(
        id: '1',
        sellerName: 'TechStore',
        profileImage: 'https://i.pravatar.cc/150?u=1',
        isLive: true,
      ),
      StoryModel(
        id: '2',
        sellerName: 'FashionHub',
        profileImage: 'https://i.pravatar.cc/150?u=2',
        isLive: true,
      ),
      StoryModel(
        id: '3',
        sellerName: 'HomeDecor',
        profileImage: 'https://i.pravatar.cc/150?u=3',
        isLive: false,
      ),
      StoryModel(
        id: '4',
        sellerName: 'BeautyBox',
        profileImage: 'https://i.pravatar.cc/150?u=4',
        isLive: true,
      ),
      StoryModel(
        id: '5',
        sellerName: 'GadgetZ',
        profileImage: 'https://i.pravatar.cc/150?u=5',
        isLive: false,
      ),
    ]);

    final mockComments = {
      '1': <CommentModel>[
        CommentModel(
          id: 'c1',
          userName: 'Alex Carter',
          userProfileUrl: 'https://i.pravatar.cc/150?u=alex',
          commentText: 'This wireless headphone is absolutely amazing! 🔥',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        CommentModel(
          id: 'c2',
          userName: 'Sarah Jenkins',
          userProfileUrl: 'https://i.pravatar.cc/150?u=sarah',
          commentText: 'Does it support active noise cancelling?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        CommentModel(
          id: 'c3',
          userName: 'David Miller',
          userProfileUrl: 'https://i.pravatar.cc/150?u=david',
          commentText: 'Wow, looks sleek and premium.',
          timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ].obs,
      '2': <CommentModel>[
        CommentModel(
          id: 'c4',
          userName: 'Emma Watson',
          userProfileUrl: 'https://i.pravatar.cc/150?u=emma',
          commentText: 'Can\'t wait for the live sale! 😍',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        CommentModel(
          id: 'c5',
          userName: 'Ryan Reynolds',
          userProfileUrl: 'https://i.pravatar.cc/150?u=ryan',
          commentText: 'Is there a discount code available?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ].obs,
      '3': <CommentModel>[
        CommentModel(
          id: 'c6',
          userName: 'Sophia Turner',
          userProfileUrl: 'https://i.pravatar.cc/150?u=sophia',
          commentText: 'Matches my living room perfectly. Gorgeous design!',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ].obs,
    };
    commentsMap.assignAll(mockComments);

    feedItems.assignAll([
      FeedItemModel(
        id: '1',
        sellerName: 'TechStore',
        title: 'Wireless Headphones Ultra',
        price: 99.00,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
        type: FeedType.post,
        likes: 12500,
        comments: mockComments['1']!.length,
      ),
      FeedItemModel(
        id: '2',
        sellerName: 'FashionHub',
        title: 'Summer Collection Live Sale',
        price: 45.00,
        imageUrl:
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        type: FeedType.live,
        likes: 8900,
        comments: mockComments['2']!.length,
      ),
      FeedItemModel(
        id: '3',
        sellerName: 'HomeDecor',
        title: 'Modern Minimalist Lamp',
        price: 120.00,
        imageUrl:
            'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        type: FeedType.post,
        likes: 3400,
        comments: mockComments['3']!.length,
      ),
    ]);

    isLoading.value = false;
  }

  RxList<CommentModel> getCommentsForItem(String itemId) {
    if (!commentsMap.containsKey(itemId)) {
      commentsMap[itemId] = <CommentModel>[].obs;
    }
    return commentsMap[itemId]!;
  }

  void addComment(String itemId, String text) {
    final currentComments = getCommentsForItem(itemId);
    currentComments.add(CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'You',
      userProfileUrl: 'https://i.pravatar.cc/150?u=you',
      commentText: text,
      timestamp: DateTime.now(),
    ));

    final index = feedItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = feedItems[index];
      feedItems[index] = FeedItemModel(
        id: item.id,
        sellerName: item.sellerName,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        type: item.type,
        likes: item.likes,
        comments: item.comments + 1,
        isLiked: item.isLiked,
      );
    }
  }

  void toggleLike(String id) {
    final index = feedItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = feedItems[index];
      feedItems[index] = FeedItemModel(
        id: item.id,
        sellerName: item.sellerName,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        type: item.type,
        likes: item.isLiked ? item.likes - 1 : item.likes + 1,
        comments: item.comments,
        isLiked: !item.isLiked,
      );
    }
  }

  void addToCart(String id) {
    Get.snackbar(
      'Success',
      'Added to cart!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
