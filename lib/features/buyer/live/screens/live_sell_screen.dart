import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_sell_controller.dart';
import '../widgets/live_comment_bubble.dart';
import '../widgets/live_pinned_product_card.dart';
import '../widgets/live_shopping_basket_sheet.dart';
import '../widgets/live_product_detail_sheet.dart';
import '../models/live_product_model.dart';

class LiveSellScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveSellScreen({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveSellController());
    final showEmojiBar = false.obs;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live Video Feed (Background Image)
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

          // 2. Dark Gradient Overlay for text readability
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

          // 3. Main Live Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP BAR ROW ---
                  Row(
                    children: [
                      // Profile Info Pill (Avatar, Name, Likes)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: NetworkImage(
                                stream.sellerProfileImage,
                              ),
                              onBackgroundImageError: (e, s) =>
                                  const Icon(Icons.person, size: 14),
                            ),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  stream.sellerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.white70,
                                      size: 8,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '10.4K',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Join Private Group Button
                      GestureDetector(
                        onTap: () => controller.joinSellerGroup(context, stream.sellerName),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.orange,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.group_add_rounded,
                                color: Colors.orange,
                                size: 11,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Join',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Overlapping Viewer Avatars + Viewer Count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 14,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundImage: const NetworkImage(
                                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&auto=format&fit=crop&q=60',
                                      ),
                                      onBackgroundImageError: (e, s) => const SizedBox.shrink(),
                                    ),
                                  ),
                                  Positioned(
                                    left: 9,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundImage: const NetworkImage(
                                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&auto=format&fit=crop&q=60',
                                      ),
                                      onBackgroundImageError: (e, s) => const SizedBox.shrink(),
                                    ),
                                  ),
                                  Positioned(
                                    left: 18,
                                    child: CircleAvatar(
                                      radius: 7,
                                      backgroundImage: const NetworkImage(
                                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&auto=format&fit=crop&q=60',
                                      ),
                                      onBackgroundImageError: (e, s) => const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              stream.viewerCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Close Button
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.black.withValues(alpha: 0.4),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  const Spacer(),

                  Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width * 0.75,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black],
                          stops: [0.0, 0.25],
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
                              padding: const EdgeInsets.only(bottom: 5),
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

                  // 2. Seller Pinned Product Card (Screenshot 1: bottom floating card)
                  Obx(() {
                    final product = controller.pinnedProduct.value;
                    if (product == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: LivePinnedProductCard(
                        product: product,
                        onBuyPressed: () => _showProductDetail(context, product),
                        onClosePressed: () => controller.pinProduct(null),
                      ),
                    );
                  }),

                  // 3. Emoji Picker Quick Bar (Toggled on/off)
                  Obx(() {
                    if (!showEmojiBar.value) return const SizedBox.shrink();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: ['😀', '😍', '🔥', '👏', '❤️'].map((emoji) {
                          return GestureDetector(
                            onTap: () {
                              controller.sendEmoji(emoji);
                              showEmojiBar.value = false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(emoji, style: const TextStyle(fontSize: 18)),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  // 4. Comment Input & Icons Row
                  Row(
                    children: [
                      // Shopping Bag Button (Left side of comments)
                      GestureDetector(
                        onTap: () => _showLiveShoppingBasket(context, controller),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.0,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag_rounded,
                                color: Colors.orange,
                                size: 20,
                              ),
                              Positioned(
                                right: -2,
                                top: -2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF42F63),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                  ),
                                  child: const Text(
                                    '99+',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Glassmorphic Input Textfield
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: controller.commentController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 1.4,
                                  ),
                                  onSubmitted: (_) => controller.addComment(),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                    hintText: 'Say something...',
                                    hintStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: false,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: controller.addComment,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF42F63),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x3DF42F63),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Emoji trigger icon
                      _buildBottomActionIcon(
                        icon: Icons.sentiment_satisfied_alt_rounded,
                        onTap: () => showEmojiBar.toggle(),
                      ),
                      const SizedBox(width: 6),

                      // Co-host/Connect icon
                      _buildBottomActionIcon(
                        icon: Icons.people_outline_rounded,
                        onTap: () {
                          Get.snackbar(
                            'Co-Host Request',
                            'Sending request to connect with the host...',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                      ),
                      const SizedBox(width: 6),

                      // Rose icon
                      _buildBottomActionIcon(
                        icon: Icons.local_florist_rounded,
                        customWidget: const Text('🌹', style: TextStyle(fontSize: 16)),
                        onTap: () => controller.sendRose(),
                      ),
                      const SizedBox(width: 6),

                      // Gift box icon
                      _buildBottomActionIcon(
                        icon: Icons.card_giftcard_rounded,
                        customWidget: const Text('🎁', style: TextStyle(fontSize: 16)),
                        onTap: () => controller.sendGift(),
                      ),
                      const SizedBox(width: 6),

                      // Share icon with badge 102
                      GestureDetector(
                        onTap: () {
                          Get.snackbar(
                            'Shared',
                            'Live stream link copied to clipboard!',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.reply_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              Positioned(
                                bottom: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '102',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 6,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionIcon({
    required IconData icon,
    Widget? customWidget,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: customWidget ?? Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
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
          sellerProfileImage: stream.sellerProfileImage,
        );
      },
    );
  }

  void _showProductDetail(BuildContext context, LiveProductModel product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black45,
      builder: (context) {
        return LiveProductDetailSheet(
          product: product,
          sellerName: stream.sellerName,
          sellerProfileImage: stream.sellerProfileImage,
        );
      },
    );
  }
}
