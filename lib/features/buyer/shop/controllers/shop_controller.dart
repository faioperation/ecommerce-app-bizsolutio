import 'package:get/get.dart';
import '../models/shop_model.dart';
import '../../discover/models/discover_product_model.dart';
import '../../discover/controllers/discover_controller.dart';

class ShopController extends GetxController {
  final isLoading = true.obs;
  final shop = Rxn<ShopModel>();
  final isFollowing = false.obs;
  
  // Products associated with this shop
  final shopProducts = <DiscoverProductModel>[].obs;

  Future<void> loadShopDetails(String sellerName, String profileImageUrl) async {
    isLoading.value = true;
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Create mock shop data
    shop.value = ShopModel(
      id: sellerName.toLowerCase().replaceAll(' ', '_'),
      name: sellerName,
      profileImageUrl: profileImageUrl,
      coverImageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=800',
      location: 'San Francisco, CA',
      followersCount: 125000, // 125K
      rating: 4.9,
      responseRate: 98,
      description: 'Welcome to $sellerName! We offer the best quality products with fast shipping and excellent customer service. Our goal is to provide a seamless shopping experience.',
      isLive: false, // You can toggle this for testing
    );

    // Fetch products for this shop from DiscoverController mock data
    try {
      final discoverCtrl = Get.find<DiscoverController>();
      shopProducts.value = discoverCtrl.products.where((p) => p.sellerName == sellerName).toList();
      
      // If none found, just provide some dummy ones
      if (shopProducts.isEmpty) {
        shopProducts.value = discoverCtrl.products.take(4).toList();
      }
    } catch (e) {
      // In case DiscoverController is not found
    }

    isLoading.value = false;
  }

  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
    Get.snackbar(
      isFollowing.value ? 'Following' : 'Unfollowed',
      isFollowing.value ? 'You are now following ${shop.value?.name}.' : 'You stopped following ${shop.value?.name}.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
