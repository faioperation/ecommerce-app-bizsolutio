import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/profile_user_model.dart';
import 'profile_controller.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Populate with existing data if available
    try {
      final profileCtrl = Get.find<ProfileController>();
      final user = profileCtrl.user.value;
      if (user != null) {
        nameController.text = user.name;
        // In a real app, user model might have phone. Just mock for now.
        phoneController.text = '+1 (555) 123-4567';
      }
    } catch (_) {}
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void pickImage() {
    // TODO: Implement image picker logic
    Get.snackbar('Image Picker', 'Coming soon!');
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Name cannot be empty', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    
    // TODO: Call API to update profile
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Update local profile controller
    try {
      final profileCtrl = Get.find<ProfileController>();
      if (profileCtrl.user.value != null) {
        final currentUser = profileCtrl.user.value!;
        profileCtrl.user.value = ProfileUserModel(
          id: currentUser.id,
          name: nameController.text.trim(),
          email: currentUser.email,
          avatarUrl: currentUser.avatarUrl,
          ordersCount: currentUser.ordersCount,
          wishlistCount: currentUser.wishlistCount,
          loyaltyPoints: currentUser.loyaltyPoints,
        );
      }
    } catch (_) {}

    isLoading.value = false;
    Get.back();
    Get.snackbar('Success', 'Profile updated successfully!', backgroundColor: Colors.green, colorText: Colors.white);
  }
}
