import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_sell_controller.dart';
import '../widgets/live_comment_bubble.dart';
import '../widgets/live_product_card.dart';
import '../widgets/live_shopping_basket_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../profile/controllers/cart_controller.dart';
import '../../profile/models/cart_item_model.dart';

class LiveSellScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveSellScreen({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveSellController());
    controller.fetchLiveProducts(); // Keep live products list fresh for this stream!

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              stream.previewImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Icon(
                  Icons.videocam_off,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.4),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: AppSpacing.edgeInsetsAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: NetworkImage(
                                  stream.sellerProfileImage,
                                ),
                                onBackgroundImageError: (e, s) =>
                                    const Icon(Icons.person),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            stream.sellerName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Colors.blueAccent,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.liveBadge,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'LIVE',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            size: 10,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            stream.viewerCount,
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            '•',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 8,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Colors.amber,
                                            size: 12,
                                          ),
                                          const SizedBox(width: 2),
                                          const Text(
                                            '4.9',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Obx(() => GestureDetector(
                                onTap: () => controller.toggleFollow(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: controller.isFollowing.value
                                        ? Colors.white.withValues(alpha: 0.2)
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: controller.isFollowing.value
                                        ? Colors.white.withValues(alpha: 0.3)
                                        : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    controller.isFollowing.value ? 'Following' : 'Follow',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Top Action Buttons
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // --- MIDDLE-LOWER PORTION (Structured Comments, Product, Input) ---

                  // 1. Scrollable real-time comments section (placed above Product card)
                  Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                          stops: [0.0, 0.2],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Obx(
                        () => ListView.builder(
                          controller: controller.scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.comments.length,
                          itemBuilder: (context, index) {
                            final item = controller.comments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: LiveCommentBubble(
                                username: item.username,
                                comment: item.text,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // 2. Product Preview Card (Stunning floating white card)
                  LiveProductCard(
                    imageUrl: stream.previewImageUrl,
                    title: 'Summer Dress Collection',
                    price: 89,
                    onBuyPressed: () {
                      final cartController = Get.isRegistered<CartController>()
                          ? Get.find<CartController>()
                          : Get.put(CartController());
                      cartController.addItem(
                        CartItemModel(
                          productId: 'live_prod_${stream.sellerName.toLowerCase().replaceAll(' ', '_')}',
                          name: 'Summer Dress Collection',
                          sellerName: stream.sellerName,
                          imageUrl: stream.previewImageUrl,
                          price: 89.0,
                          quantity: 1,
                        ),
                      );
                      context.push(AppRoutes.profileCart);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Comment Input Row (Comment box + Heart toggle)
                  Row(
                    children: [
                      // Glassmorphic Input Textfield
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                  onSubmitted: (_) => controller.addComment(),
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 13,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.orangeAccent,
                                  size: 18,
                                ),
                                onPressed: controller.addComment,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Heart Toggle Button
                      GestureDetector(
                        onTap: controller.toggleLike,
                        child: Obx(
                          () => CircleAvatar(
                            radius: 24,
                            backgroundColor: controller.isLiked.value
                                ? Colors.pink.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.5),
                            child: Icon(
                              controller.isLiked.value
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 220, // Positioned beautifully above the product card
            child: GestureDetector(
              onTap: () => _showLiveShoppingBasket(context, controller),
              child: Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                    Obx(() {
                      final cartController = Get.isRegistered<CartController>()
                          ? Get.find<CartController>()
                          : Get.put(CartController());
                      final count = cartController.totalItemCount;
                      if (count == 0) return const SizedBox.shrink();
                      return Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLiveShoppingBasket(BuildContext context, LiveSellController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return LiveShoppingBasketSheet(
          controller: controller,
          sellerName: stream.sellerName,
        );
      },
    );
  }
}
