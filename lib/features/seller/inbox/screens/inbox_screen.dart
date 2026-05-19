import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_routes.dart';
import '../../../buyer/inbox/controllers/inbox_controller.dart';
import '../../../buyer/inbox/widgets/chat_list_tile.dart';

class SellerInboxScreen extends StatelessWidget {
  const SellerInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reuse the same singleton InboxController shared with buyer inbox
    final ctrl = Get.isRegistered<InboxController>()
        ? Get.find<InboxController>()
        : Get.put(InboxController(), permanent: true);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (ctrl.chatList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 72,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'No messages yet',
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.chatList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final chat = ctrl.chatList[index];
            return Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE5E7EB),
                ),
              ),
              child: ChatListTile(
                chat: chat,
                onTap: () => context.push(
                  AppRoutes.chatScreen,
                  extra: {
                    'chatId': chat.id,
                    'shopName': chat.name,
                    'profileImage': chat.profileImage,
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
