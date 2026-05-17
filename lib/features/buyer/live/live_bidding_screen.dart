import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import '../home/models/live_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class LiveBiddingScreen extends StatefulWidget {
  final LiveStreamModel stream;

  const LiveBiddingScreen({super.key, required this.stream});

  @override
  State<LiveBiddingScreen> createState() => _LiveBiddingScreenState();
}

class _LiveBiddingScreenState extends State<LiveBiddingScreen> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  // Bid Activity and comments feed
  final List<Map<String, dynamic>> _activities = [
    {'username': 'Buyer123', 'text': 'How much? 🤔', 'isBid': false},
    {'username': 'alex', 'text': 'Start auction 🔥', 'isBid': false},
    {'username': 'Nime', 'text': 'placed £420', 'isBid': true},
    {'username': 'Buyer5855', 'text': 'This is amazing!', 'isBid': false},
    {'username': 'Alex', 'text': 'placed £450', 'isBid': true},
  ];

  bool _isLiked = false;

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addActivity() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Check if the typed comment looks like a bid, e.g. "460" or "placed 460"
    bool isBid = text.toLowerCase().contains('placed') || 
                 text.toLowerCase().contains('£') || 
                 RegExp(r'\d+').hasMatch(text);

    setState(() {
      _activities.add({
        'username': 'You',
        'text': isBid ? 'placed $text' : text,
        'isBid': isBid,
      });
      _commentController.clear();
    });

    // Auto-scroll to bottom
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

                  const SizedBox(height: 20),

                  // --- MIDDLE PORTION (Structured Bids & Comments Feed) ---
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
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _activities.length,
                          itemBuilder: (context, index) {
                            final act = _activities[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildBidBubble(act['username']!, act['text']!, isBid: act['isBid']!),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // --- LOWER PORTION (Live Auction Premium Card & Comment Field) ---
                  
                  // Auction Stats Card (Glowing border container)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1A29).withValues(alpha: 0.95),
                      borderRadius: AppSpacing.borderRadiusLg,
                      border: Border.all(color: AppColors.accentPink.withValues(alpha: 0.6), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPink.withValues(alpha: 0.25),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header (AUCTION indicator & Time countdown)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'LIVE AUCTION',
                                  style: TextStyle(
                                    color: Colors.orangeAccent[100],
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.access_time_filled, color: Colors.redAccent, size: 12),
                                  SizedBox(width: 4),
                                  Text(
                                    '00:19',
                                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Product Thumbnail & Price details
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                widget.stream.previewImageUrl,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'iPhone 15 Pro Max 256GB',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(text: 'Current Bid: ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                        TextSpan(
                                          text: '£450',
                                          style: TextStyle(
                                            color: Colors.orangeAccent, 
                                            fontWeight: FontWeight.w900, 
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Divider(color: Colors.white24, height: 1),
                        const SizedBox(height: 12),

                        // Stats metrics
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn('Highest Bidder', 'Alex'),
                            _buildStatColumn('Total Bids', '${_activities.where((act) => act['isBid'] == true).length}'),
                            _buildStatColumn('Starting Price', '£350'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Place Bid Premium Gradient Button
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE11D48), Color(0xFFDB2777)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFDB2777).withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _activities.add({
                                  'username': 'You',
                                  'text': 'placed £460',
                                  'isBid': true,
                                });
                              });
                              Get.snackbar(
                                'Bid Placed!', 
                                'You successfully placed a bid of £460!',
                                backgroundColor: AppColors.accentPink.withValues(alpha: 0.9),
                                colorText: Colors.white,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.trending_up, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Place Bid', 
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Comment row (High-end Glassmorphic Text input + Heart button)
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
                              color: AppColors.accentPink.withValues(alpha: 0.4), 
                              width: 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentPink.withValues(alpha: 0.05),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                  onSubmitted: (_) => _addActivity(),
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment or enter a bid...',
                                    hintStyle: TextStyle(color: Colors.white54, fontSize: 13),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send_rounded, color: AppColors.accentPink, size: 18),
                                onPressed: _addActivity,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Dynamic Heart/Love Toggle Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          Get.snackbar(
                            _isLiked ? 'Loved!' : 'Unliked', 
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

  Widget _buildBidBubble(String username, String text, {required bool isBid}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isBid 
              ? Colors.orange.withValues(alpha: 0.8) 
              : Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: isBid ? Border.all(color: Colors.amberAccent, width: 1.0) : null,
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 12, color: Colors.white),
            children: [
              TextSpan(
                text: '$username ',
                style: TextStyle(
                  color: isBid ? Colors.white : Colors.orangeAccent, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isBid ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
