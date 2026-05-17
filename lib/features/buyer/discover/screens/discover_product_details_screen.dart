import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../controllers/discover_controller.dart';
import '../models/discover_product_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class DiscoverProductDetailsScreen extends StatefulWidget {
  final DiscoverProductModel? product;

  const DiscoverProductDetailsScreen({super.key, this.product});

  @override
  State<DiscoverProductDetailsScreen> createState() => _DiscoverProductDetailsScreenState();
}

class _DiscoverProductDetailsScreenState extends State<DiscoverProductDetailsScreen> {
  bool _isLiked = false;
  bool _isFollowing = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DiscoverController>();
    final activeProduct = widget.product ?? controller.products.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // 1. Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image (Screenshot 3 upper part)
                Hero(
                  tag: 'product-img-${activeProduct.id}',
                  child: Image.network(
                    activeProduct.imageUrl,
                    height: 380,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 380,
                      color: Colors.grey[200],
                      child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 80),
                    ),
                  ),
                ),

                // 2. White Info Box (Curved bottom sheet style overlay)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF13101E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bottom sheet drag handle indicator
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Product Title
                      Text(
                        activeProduct.name,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Rating & review row (Screenshot 3)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${activeProduct.rating}',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '(${activeProduct.reviewCount} reviews) • ${activeProduct.soldCount ~/ 1000}K sold',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Price Section with Crossed Price and Discount Badge (Screenshot 3)
                      Row(
                        children: [
                          Text(
                            '£${activeProduct.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '£${activeProduct.originalPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                              fontSize: 16,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED), // Soft Peach bg
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${activeProduct.discountPercentage}% OFF',
                              style: const TextStyle(
                                color: Color(0xFFEA580C),
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Seller Section with Profile Card and Follow Button (Screenshot 3)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(activeProduct.sellerProfileImage),
                              onBackgroundImageError: (e, s) => const Icon(Icons.person),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeProduct.sellerName,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${activeProduct.sellerRating} rating',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Purple Follow button
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isFollowing = !_isFollowing;
                                });
                                Get.snackbar(
                                  _isFollowing ? 'Following Shop' : 'Unfollowed Shop', 
                                  _isFollowing ? 'You are now following ${activeProduct.sellerName}!' : 'You unfollowed.',
                                  backgroundColor: const Color(0xFF6C4DFF),
                                  colorText: Colors.white,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFollowing ? Colors.grey[400] : const Color(0xFF6C4DFF),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                minimumSize: Size.zero,
                              ),
                              child: Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Delivery & Return highlights row (Screenshot 3 Icons)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHighlightItem(Icons.local_shipping_outlined, 'Free Shipping', isDark),
                          _buildHighlightItem(Icons.shield_outlined, 'Warranty', isDark),
                          _buildHighlightItem(Icons.replay_circle_filled_rounded, '30-Day Return', isDark),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description Header
                      Text(
                        'Description',
                        style: TextStyle(
                          color: isDark ? Colors.white : const Color(0xFF111827),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Description Text
                      Text(
                        activeProduct.description,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[600],
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 100), // Spacing for bottom navbar
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Overlay Top Buttons (Screenshot 3 style)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circular Back Button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 18),
                  ),
                ),
                Row(
                  children: [
                    // Share Button
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 18),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Favorite Heart Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                        Get.snackbar(
                          _isLiked ? 'Added to Wishlist' : 'Removed from Wishlist', 
                          _isLiked ? '${activeProduct.name} added to wishlist.' : 'Removed.',
                          backgroundColor: _isLiked ? Colors.pinkAccent : Colors.black87,
                          colorText: Colors.white,
                        );
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border_rounded, 
                          color: _isLiked ? Colors.pink : Colors.black87, 
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Fixed Bottom Action Row (Add to Cart & Buy Now Buttons)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF13101E) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Add To Cart Button (White bg, purple border/text)
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF6C4DFF), width: 1.5),
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.addToCart(activeProduct),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Color(0xFF6C4DFF),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Buy Now Button (Purple background, white text)
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C4DFF), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C4DFF).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => controller.buyNow(activeProduct),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String label, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF3F4F6),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF6C4DFF), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey[700],
            fontSize: 11,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}
