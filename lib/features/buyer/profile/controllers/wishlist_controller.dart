import 'package:get/get.dart';
import '../models/wishlist_item_model.dart';

/// Controls the My Wishlist screen.
/// Replace mock data with real API calls when ready.
class WishlistController extends GetxController {
  final isLoading = false.obs;
  final items = <WishlistItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  /// TODO: Replace with real API call → GET /api/buyer/wishlist
  Future<void> loadWishlist() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

    items.value = [
      WishlistItemModel(
        productId: 'prod1',
        name: 'Smart Watch Ultra',
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=200',
        price: 299.0,
        originalPrice: 399.0,
        isInStock: true,
      ),
      WishlistItemModel(
        productId: 'prod5',
        name: 'Wireless Headphones Pro',
        imageUrl: 'https://images.unsplash.com/photo-1484704849700-f032a568e944?q=80&w=200',
        price: 99.0,
        originalPrice: 149.0,
        isInStock: true,
      ),
      WishlistItemModel(
        productId: 'prod6',
        name: 'Designer Sunglasses',
        imageUrl: 'https://images.unsplash.com/photo-1508296695146-257a814070b4?q=80&w=200',
        price: 79.0,
        originalPrice: 129.0,
        isInStock: false,
      ),
    ];

    isLoading.value = false;
  }

  /// TODO: Replace with real API call → DELETE /api/buyer/wishlist/{productId}
  void removeItem(String productId) {
    items.removeWhere((i) => i.productId == productId);
    Get.snackbar('Removed', 'Item removed from wishlist',
        duration: const Duration(seconds: 2));
  }

  /// TODO: Replace with real API call → POST /api/buyer/cart
  void addToCart(WishlistItemModel item) {
    Get.snackbar('Added to Cart', '${item.name} added to your cart!',
        duration: const Duration(seconds: 2));
  }
}
