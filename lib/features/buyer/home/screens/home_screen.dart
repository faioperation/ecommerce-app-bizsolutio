import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_widgets.dart';
import '../widgets/feed_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_controller.dart';

class BuyerHomeScreen extends StatelessWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Vango Live',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface
          ),
        ),
        actions: [
          Obx(() {
            final themeController = Get.find<ThemeController>();
            return IconButton(
              icon: Icon(
                themeController.themeMode.value == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () => themeController.toggleTheme(),
            );
          }),
          IconButton(
            icon: Badge(
              label: const Text('2'),
              child: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.onSurface),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.loadMockData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.edgeInsetsAllLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 110,
                  child: Obx(() => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.stories.length,
                    itemBuilder: (context, index) {
                      final story = controller.stories[index];
                      return StoryCard(
                        imageUrl: story.profileImage,
                        name: story.sellerName,
                        isLive: story.isLive,
                      );
                    },
                  )),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    HomeCategoryButton(
                      label: 'Flash Sale',
                      icon: Icons.flash_on,
                      gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                      onTap: () => Get.snackbar('Info', 'Flash Sale Screen coming soon!'),
                    ),
                    const SizedBox(width: 12),
                    HomeCategoryButton(
                      label: 'Trending',
                      icon: Icons.trending_up,
                      gradient: const [Color(0xFF6C4DFF), Color(0xFF4F46E5)],
                      onTap: () => context.push(AppRoutes.trending),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    HomeCategoryButton(
                      label: 'Live Now',
                      icon: Icons.play_circle_outline,
                      gradient: const [Color(0xFFFF4D67), Color(0xFFE11D48)],
                      onTap: () => context.push(AppRoutes.liveNow),
                    ),
                    const SizedBox(width: 12),
                    HomeCategoryButton(
                      label: 'Following',
                      icon: Icons.people_outline,
                      gradient: const [Color(0xFFFF4FD8), Color(0xFFDB2777)],
                      onTap: () => context.push(AppRoutes.following),
                    ),
                  ],
                ),

                const SectionTitle(title: 'For You'),

                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.feedItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.feedItems[index];
                    return FeedCard(
                      item: item,
                      onLike: () => controller.toggleLike(item.id),
                      onComment: () => Get.snackbar('Info', 'Comments Screen coming soon!'),
                      onShare: () => Get.snackbar('Info', 'Share functionality coming soon!'),
                      onAddToCart: () => controller.addToCart(item.id),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
