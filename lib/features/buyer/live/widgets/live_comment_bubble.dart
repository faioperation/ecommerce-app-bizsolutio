import 'package:flutter/material.dart';

class LiveCommentBubble extends StatelessWidget {
  final String username;
  final String comment;

  const LiveCommentBubble({
    super.key,
    required this.username,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
            children: [
              TextSpan(
                text: '$username: ',
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: comment,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
