import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/live_activity_model.dart';

class LiveSellController extends GetxController {
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  final comments = <LiveActivityModel>[
    LiveActivityModel(
      username: 'user123',
      text: 'This looks amazing! 😍',
      isBid: false,
    ),
    LiveActivityModel(
      username: 'shopper456',
      text: "What's the price?",
      isBid: false,
    ),
    LiveActivityModel(
      username: 'buyer789',
      text: 'Just ordered one!',
      isBid: false,
    ),
  ].obs;

  final isLiked = false.obs;

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
