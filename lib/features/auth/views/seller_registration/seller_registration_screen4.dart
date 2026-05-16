import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/seller_registration_controller.dart';

class SellerRegistrationScreen4 extends StatelessWidget {
  const SellerRegistrationScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellerRegistrationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Branding'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.edgeInsetsAllLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Style your Store',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a logo and banner to make your shop stand out.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            
            const Text('Shop Logo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => controller.showImageSourceDialog(context, (path) => controller.logoPath.value = path),
                child: Stack(
                  children: [
                    Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFFF3F4F6),
                      backgroundImage: controller.logoPath.value.isNotEmpty ? FileImage(File(controller.logoPath.value)) : null,
                      child: controller.logoPath.value.isEmpty ? const Icon(Icons.store, size: 40, color: Colors.grey) : null,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            const Text('Shop Banner', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => controller.showImageSourceDialog(context, (path) => controller.bannerPath.value = path),
              child: Obx(() => Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: AppSpacing.borderRadiusMd,
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  image: controller.bannerPath.value.isNotEmpty 
                      ? DecorationImage(image: FileImage(File(controller.bannerPath.value)), fit: BoxFit.cover) 
                      : null,
                ),
                child: controller.bannerPath.value.isEmpty 
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Upload Banner (1200 x 400)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    )
                  : null,
              )),
            ),
            const SizedBox(height: 32),
            
            const Text('Shop Description', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Tell customers what you sell and why they should follow you...',
              ),
              onChanged: (val) => controller.description.value = val,
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.sellerRegStep5),
                child: const Text('Next Step', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
