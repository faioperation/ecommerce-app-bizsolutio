import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/store_model.dart';

/// GetX controller for managing the Store Profile data and user actions.
/// Designed for easy integration with future REST/GraphQL endpoints.
class StoreController extends GetxController {
  final Rxn<StoreModel> store = Rxn<StoreModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStoreData();
  }

  /// Simulation of fetching store data from a remote API
  void loadStoreData() async {
    isLoading.value = true;
    
    // Simulate short network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Seed mock data that matches the client's mockup screenshot exactly
    store.value = StoreModel(
      id: 'store_123',
      name: 'My Store',
      category: 'Electronics & Fashion',
      avatar: '🏪', // 24/7 Store Emoji matching mockup
      followers: 2458,
      rating: 4.8,
      productsCount: 127,
      featuredProducts: [
        StoreProductModel(
          id: 'p1',
          title: 'Premium Watch',
          price: 299.0,
          image: '⌚', // Watch emoji
        ),
        StoreProductModel(
          id: 'p2',
          title: 'Leather Bag',
          price: 159.0,
          image: '👜', // Handbag emoji
        ),
        StoreProductModel(
          id: 'p3',
          title: 'Wireless Headphones',
          price: 199.0,
          image: '🎧', // Headphone emoji
        ),
        StoreProductModel(
          id: 'p4',
          title: 'Smart Fitness Band',
          price: 89.0,
          image: '⌚', // Smart band emoji
        ),
      ],
    );

    isLoading.value = false;
  }

  /// Dynamic action for sharing the store (simulates copying link)
  void shareStore(BuildContext context) {
    if (store.value == null) return;
    
    // Simulate copy to clipboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Store link for "${store.value!.name}" copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF6C4DFF), // Matches primary color
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Dynamic action for editing the store details
  void editStore(BuildContext context) {
    if (store.value == null) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to Edit settings for "${store.value!.name}"...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Dynamic action for the settings button on AppBar
  void openSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Store Settings options...'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.blueGrey,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
