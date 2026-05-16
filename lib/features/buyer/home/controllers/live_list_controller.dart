import 'package:get/get.dart';
import '../models/live_model.dart';

class LiveListController extends GetxController {
  final RxList<LiveStreamModel> liveStreams = <LiveStreamModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    isLoading.value = true;
    liveStreams.assignAll([
      LiveStreamModel(
        id: '1',
        title: 'Summer Fashion Sale 🔥',
        sellerName: 'FashionHub',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=fashion',
        previewImageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&q=80',
        viewerCount: '8,234',
        productCount: 15,
      ),
      LiveStreamModel(
        id: '2',
        title: 'Unboxing Latest Gadgets',
        sellerName: 'TechStore',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=tech',
        previewImageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&q=80',
        viewerCount: '5,621',
        productCount: 8,
      ),
      LiveStreamModel(
        id: '3',
        title: 'Minimalist Home Decor Live',
        sellerName: 'HomeDecor',
        sellerProfileImage: 'https://i.pravatar.cc/150?u=home',
        previewImageUrl: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=800&q=80',
        viewerCount: '3,105',
        productCount: 12,
      ),
    ]);
    isLoading.value = false;
  }
}
