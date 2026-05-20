import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/live_broadcast_controller.dart';

class LiveChatList extends StatelessWidget {
  final LiveBroadcastController controller;

  const LiveChatList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final comments = controller.comments;
      return ListView.separated(
        reverse: true, // Show newest messages at the bottom
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: comments.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // Because of reverse: true, index 0 is the newest, which is at the end of the list
          final comment = comments[comments.length - 1 - index];
          final isSeller = comment.userName.contains('(You)');
          
          return GestureDetector(
            onTap: () => controller.setReplyTo(comment),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: controller.replyingToComment.value?.id == comment.id 
                    ? Colors.white.withValues(alpha: 0.1) 
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: TextStyle(
                      color: isSeller ? const Color(0xFF6C4DFF) : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      shadows: const [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    comment.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
