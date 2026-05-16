import 'package:get/get.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  final RxList<StoryModel> stories = <StoryModel>[].obs;
  final RxList<FeedItemModel> feedItems = <FeedItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;

    stories.assignAll([
      StoryModel(id: '1', sellerName: 'TechStore', profileImage: 'https://i.pravatar.cc/150?u=1', isLive: true),
      StoryModel(id: '2', sellerName: 'FashionHub', profileImage: 'https://i.pravatar.cc/150?u=2', isLive: true),
      StoryModel(id: '3', sellerName: 'HomeDecor', profileImage: 'https://i.pravatar.cc/150?u=3', isLive: false),
      StoryModel(id: '4', sellerName: 'BeautyBox', profileImage: 'https://i.pravatar.cc/150?u=4', isLive: true),
      StoryModel(id: '5', sellerName: 'GadgetZ', profileImage: 'https://i.pravatar.cc/150?u=5', isLive: false),
    ]);

    feedItems.assignAll([
      FeedItemModel(
        id: '1',
        sellerName: 'TechStore',
        title: 'Wireless Headphones Ultra',
        price: 99.00,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&q=80',
        type: FeedType.post,
        likes: 12500,
        comments: 432,
      ),
      FeedItemModel(
        id: '2',
        sellerName: 'FashionHub',
        title: 'Summer Collection Live Sale',
        price: 45.00,
        imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        type: FeedType.live,
        likes: 8900,
        comments: 215,
      ),
      FeedItemModel(
        id: '3',
        sellerName: 'HomeDecor',
        title: 'Modern Minimalist Lamp',
        price: 120.00,
        imageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        type: FeedType.post,
        likes: 3400,
        comments: 89,
      ),
    ]);

    isLoading.value = false;
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

    Get.snackbar('Success', 'Added to cart!', snackPosition: SnackPosition.BOTTOM);
  }
}
