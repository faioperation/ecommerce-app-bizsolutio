import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../home/models/live_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveSellScreen extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveSellScreen({super.key, required this.stream});

  @override
  State<LiveSellScreen> createState() => _LiveSellScreenState();
}

class _LiveSellScreenState extends State<LiveSellScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Real-time reactive comment list
  final List<Map<String, String>> _comments = [
    {'username': 'user123', 'comment': 'This looks amazing! 😍'},
    {'username': 'shopper456', 'comment': "What's the price?"},
    {'username': 'buyer789', 'comment': 'Just ordered one!'},
  ];

  bool _isLiked = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _comments.add({
        'username': 'You',
        'comment': text,
      });
      _commentController.clear();
    });

    // Auto-scroll to bottom of comments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Live stream background image (full screen)
          Positioned.fill(
            child: Image.network(
              widget.stream.previewImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.videocam_off, color: Colors.white, size: 80),
              ),
            ),
          ),

          // Dark overlay gradient to make floating text stand out
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

          // 2. Safe Area Layout
          SafeArea(
            child: Padding(
              padding: AppSpacing.edgeInsetsAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TOP BAR (Seller Info, Share, Close) ---
                  Row(
                    children: [
                      // Profile & Stream Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(widget.stream.sellerProfileImage),
                              onBackgroundImageError: (e, s) => const Icon(Icons.person),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.stream.sellerName,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.liveBadge,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(Icons.remove_red_eye_outlined, color: Colors.white.withValues(alpha: 0.8), size: 10),
                                    const SizedBox(width: 2),
                                    Text(
                                      widget.stream.viewerCount,
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 9, fontWeight: FontWeight.bold),
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
                          icon: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // --- MIDDLE-LOWER PORTION (Structured Comments on top, Product, Input below) ---
                  
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
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final item = _comments[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _buildCommentRow(item['username']!, item['comment']!),
                          );
                        },
                      ),
                    ),
                  ),

                  // 2. Product Preview Card (Stunning floating white card)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: AppSpacing.borderRadiusLg,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Product image thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.stream.previewImageUrl,
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title & Price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Summer Dress Collection',
                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '£89',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Buy button
                        ElevatedButton(
                          onPressed: () {
                            Get.snackbar(
                              'Success', 
                              'Summer Dress added to cart!',
                              backgroundColor: AppColors.success.withValues(alpha: 0.9),
                              colorText: Colors.white,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Buy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ],
                    ),
                  ),

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
                            border: Border.all(color: Colors.white.withValues(alpha: 0.25), width: 1.0),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onSubmitted: (_) => _addComment(),
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(color: Colors.white60, fontSize: 13),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send_rounded, color: Colors.orangeAccent, size: 18),
                                onPressed: _addComment,
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
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          Get.snackbar(
                            _isLiked ? 'Loved!' : 'Unloved', 
                            _isLiked ? 'You liked the live stream!' : 'You removed your like.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: _isLiked 
                                ? Colors.pink.withValues(alpha: 0.8) 
                                : Colors.black87.withValues(alpha: 0.8),
                            colorText: Colors.white,
                            duration: const Duration(seconds: 1),
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: _isLiked 
                              ? Colors.pink.withValues(alpha: 0.9) 
                              : Colors.black.withValues(alpha: 0.5),
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border, 
                            color: Colors.white, 
                            size: 22,
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

  Widget _buildCommentRow(String username, String comment) {
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
            style: const TextStyle(fontSize: 12),
            children: [
              TextSpan(
                text: '$username: ',
                style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
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
