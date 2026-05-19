import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../../home/models/live_model.dart';
import '../controllers/live_bidding_controller.dart';
import '../widgets/live_bid_bubble.dart';
import '../widgets/auction_stats_card.dart';
import '../widgets/congratulations_dialog.dart';
import '../widgets/auction_ended_banner.dart';
import '../widgets/place_bid_bottom_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveBiddingScreen extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveBiddingScreen({super.key, required this.stream});

  void _showCongratulationsDialog(
    BuildContext context,
    LiveBiddingController controller,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CongratulationsDialog(
          previewImageUrl: stream.previewImageUrl,
          winningBid: controller.currentBid.value,
          onProceedToPayment: () {
            Navigator.of(context).pop();
            Get.snackbar(
              'Checkout',
              'Redirecting to secure payment portal...',
              backgroundColor: AppColors.success,
              colorText: Colors.white,
            );
          },
        );
      },
    );
  }

  void _openBidBottomSheet(
    BuildContext context,
    LiveBiddingController controller,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PlaceBidBottomSheet(
          currentBid: controller.currentBid.value,
          onBidConfirmed: (amount) => controller.placeBid(amount),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveBiddingController());

    controller.onAuctionWonCallback = () =>
        _showCongratulationsDialog(context, controller);

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
                    Colors.black.withValues(alpha: 0.8),
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
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(
                            Icons.refresh_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          tooltip: 'Reset Demo Auction',
                          onPressed: controller.resetAuction,
                        ),
                      ),
                      const SizedBox(width: 8),
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
                      const SizedBox(width: 8),
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

                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black],
                            stops: [0.0, 0.15],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Obx(
                          () => ListView.builder(
                            controller: controller.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.activities.length,
                            itemBuilder: (context, index) {
                              final act = controller.activities[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: LiveBidBubble(
                                  username: act.username,
                                  text: act.text,
                                  isBid: act.isBid,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => AuctionStatsCard(
                      previewImageUrl: stream.previewImageUrl,
                      currentBid: controller.currentBid.value,
                      highestBidder: controller.highestBidder.value,
                      totalBids: controller.totalBids.value,
                      secondsRemaining: controller.secondsRemaining.value,
                      onPlaceBidPressed: () =>
                          _openBidBottomSheet(context, controller),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.accentPink.withValues(
                                alpha: 0.4,
                              ),
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPink.withValues(
                                  alpha: 0.05,
                                ),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => TextField(
                                    controller: controller.commentController,
                                    enabled: !controller.isAuctionEnded.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                    onSubmitted: (_) => controller.addComment(),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Add a comment or enter a bid...',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: AppColors.accentPink,
                                    size: 18,
                                  ),
                                  onPressed: controller.isAuctionEnded.value
                                      ? null
                                      : controller.addComment,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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

          Obx(() {
            if (controller.showEndBanner.value) {
              return Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: AuctionEndedBanner(
                  highestBidder: controller.highestBidder.value,
                  finalBid: controller.currentBid.value,
                  onClosePressed: () {
                    controller.showEndBanner.value = false;
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
