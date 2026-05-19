import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_sell_controller.dart';
import '../widgets/live_comment_bubble.dart';
import '../widgets/live_product_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveSellScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveSellScreen({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveSellController());

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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  stream.sellerName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
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
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
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
                      Get.snackbar(
                        'Success',
                        'Summer Dress added to cart!',
                        backgroundColor: AppColors.success.withValues(
                          alpha: 0.9,
                        ),
                        colorText: Colors.white,
                      );
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
        ],
      ),
    );
  }
}
