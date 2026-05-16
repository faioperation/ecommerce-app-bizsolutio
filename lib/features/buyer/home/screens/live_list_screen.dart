import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/live_list_controller.dart';
import '../widgets/live_stream_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveListScreen extends StatelessWidget {
  const LiveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LiveListController());

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Shopping',
              style: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Obx(() => Text(
              '${controller.liveStreams.length} live streams now',
              style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
            )),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.liveBadge.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.liveBadge.withValues(alpha: 0.5)),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: AppColors.liveBadge),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: TextStyle(color: AppColors.liveBadge, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          padding: AppSpacing.edgeInsetsAllLg,
          itemCount: controller.liveStreams.length,
          itemBuilder: (context, index) {
            return LiveStreamCard(stream: controller.liveStreams[index]);
          },
        );
      }),
    );
  }
}
