import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live_activity_model.dart';
import '../models/live_product_model.dart';

class LiveSellController extends GetxController {
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  final liveProducts = <LiveProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLiveProducts();
  }

  void fetchLiveProducts() {
    // API Swappable Endpoint: Fetch queued products for this livestream session.
    liveProducts.assignAll([
      LiveProductModel(
        id: 'live_prod_1',
        number: 1,
        title: 'Summer Dress Collection',
        price: 89.0,
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        isCurrentlyFeatured: true,
        isUpcoming: false,
      ),
      LiveProductModel(
        id: 'live_prod_2',
        number: 2,
        title: 'Premium Silk Scarf',
        price: 29.0,
        imageUrl: 'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        isCurrentlyFeatured: false,
        isUpcoming: true,
      ),
      LiveProductModel(
        id: 'live_prod_3',
        number: 3,
        title: 'Pearl Drop Earrings',
        price: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        isCurrentlyFeatured: false,
        isUpcoming: true,
      ),
      LiveProductModel(
        id: 'live_prod_4',
        number: 4,
        title: 'Floral Maxi Skirt',
        price: 65.0,
        imageUrl: 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
        isCurrentlyFeatured: false,
        isUpcoming: true,
      ),
    ]);
  }

  final comments = <LiveActivityModel>[
    LiveActivityModel(
      username: 'John Smith',
      text: 'This looks amazing! 😍',
      isBid: false,
    ),
    LiveActivityModel(
      username: 'John Smith',
      text: "What's the price?",
      isBid: false,
    ),
    LiveActivityModel(
      username: 'John Smith',
      text: 'Just ordered one!',
      isBid: false,
    ),
  ].obs;

  final isLiked = false.obs;
  final isFollowing = false.obs;

  void toggleFollow() {
    isFollowing.toggle();
    Get.snackbar(
      isFollowing.value ? 'Following' : 'Unfollowed',
      isFollowing.value
          ? 'You are now following this seller!'
          : 'You unfollowed this seller.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isFollowing.value
          ? Colors.green.withValues(alpha: 0.9)
          : Colors.black87.withValues(alpha: 0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void onClose() {
    commentController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void addComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    comments.add(LiveActivityModel(username: 'You', text: text, isBid: false));
    commentController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleLike() {
    isLiked.toggle();
    Get.snackbar(
      isLiked.value ? 'Loved!' : 'Unloved',
      isLiked.value ? 'You liked the live stream!' : 'You removed your like.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isLiked.value
          ? Colors.pink.withValues(alpha: 0.8)
          : Colors.black87.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
}
