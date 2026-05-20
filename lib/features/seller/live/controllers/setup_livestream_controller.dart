import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Store/controllers/store_controller.dart';
import '../../Store/models/store_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/live_session_data.dart';

/// GetX Controller that manages the state of the Setup Livestream form.
/// Integrates dynamically with StoreController to retrieve and select
/// from the active seller's store products.
class SetupLivestreamController extends GetxController {
  // Lazy getter: safely resolves StoreController regardless of navigation order.
  // If the user navigates to Setup Livestream before visiting the Store tab,
  // StoreController won't be registered yet — so we create it on demand.
  StoreController get _storeController {
    if (!Get.isRegistered<StoreController>()) {
      Get.put(StoreController());
    }
    return Get.find<StoreController>();
  }

  // Reactive state fields
  final RxnString coverImagePath = RxnString();
  final RxList<StoreProductModel> selectedProducts = <StoreProductModel>[].obs;
  late TextEditingController titleController;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController();
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  /// Get the active seller's store products from the StoreController
  List<StoreProductModel> get storeProducts {
    return _storeController.store.value?.featuredProducts ?? [];
  }

  /// Update the livestream cover image path reactively
  void updateCoverImage(String? path) {
    coverImagePath.value = path;
  }

  /// Toggle selection state of a product to feature in the stream
  void toggleProductSelection(StoreProductModel product) {
    final existingIndex = selectedProducts.indexWhere((p) => p.id == product.id);
    if (existingIndex != -1) {
      selectedProducts.removeAt(existingIndex);
    } else {
      selectedProducts.add(product);
    }
  }

  /// Launch the livestream mock session (validates inputs and returns data for preview)
  LiveSessionData? validateAndSubmit(BuildContext context) {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a stream title.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    if (selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one product to feature.'),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return null;
    }

    // Map store products to lightweight LiveStreamProduct models
    final liveProducts = selectedProducts.map((p) => LiveStreamProduct(
      id: p.id,
      title: p.title,
      price: p.price,
      image: p.image,
    )).toList();

    return LiveSessionData(
      title: title,
      coverImagePath: coverImagePath.value,
      selectedProducts: liveProducts,
    );
  }
}
