import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../Store/widgets/dashed_rect_painter.dart';
import '../../Store/widgets/settings_text_field.dart';
import '../controllers/setup_livestream_controller.dart';
import '../widgets/live_product_selection_card.dart';
import '../widgets/tips_card.dart';
import '../../../../core/theme/app_colors.dart';

/// The central Setup Livestream screen allowing sellers to configure
/// their upcoming live stream broadcast details.
class SetupLivestreamScreen extends StatefulWidget {
  const SetupLivestreamScreen({super.key});

  @override
  State<SetupLivestreamScreen> createState() => _SetupLivestreamScreenState();
}

class _SetupLivestreamScreenState extends State<SetupLivestreamScreen> {
  final SetupLivestreamController _controller = Get.put(SetupLivestreamController());
  final ImagePicker _picker = ImagePicker();

  /// Pick cover photo from local phone storage gallery
  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        _controller.updateCoverImage(image.path);
      }
    } catch (e) {
      debugPrint('Error picking stream cover image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick cover image. Please grant storage access.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Handles submit execution
  void _handleSubmit() {
    final sessionData = _controller.validateAndSubmit(context);
    if (sessionData != null) {
      context.push('/seller/live-preview', extra: sessionData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Theme-specific background parameters
    final Color backgroundColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final Color cardColor = isDark ? AppColors.darkCard : Colors.white;
    final Color labelColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final Color borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Setup Livestream',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Cover Image Header
                  Text(
                    'Cover Image',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Dotted Cover Picker / Preview Box
                  Obx(() {
                    final coverPath = _controller.coverImagePath.value;
                    
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: coverPath != null
                          ? Container(
                              key: const ValueKey('preview'),
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: FileImage(File(coverPath)),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black.withValues(alpha: 0.35),
                                    ),
                                  ),
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: _pickCoverImage,
                                          icon: const Icon(Icons.edit, size: 16),
                                          label: const Text('Change'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: AppColors.lightTextPrimary,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton.icon(
                                          onPressed: () => _controller.updateCoverImage(null),
                                          icon: const Icon(Icons.delete_outline, size: 16),
                                          label: const Text('Remove'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.error,
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              key: const ValueKey('upload'),
                              onTap: _pickCoverImage,
                              borderRadius: BorderRadius.circular(16),
                              child: CustomPaint(
                                painter: DashedRectPainter(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                  borderRadius: 16,
                                  dash: 6,
                                  gap: 4,
                                  strokeWidth: 1.5,
                                ),
                                child: Container(
                                  height: 160,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 44,
                                        color: labelColor.withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Upload cover image',
                                        style: TextStyle(
                                          color: labelColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    );
                  }),
                  const SizedBox(height: 24),
                  
                  // 2. Stream Title Form
                  SettingsTextField(
                    label: 'Stream Title',
                    controller: _controller.titleController,
                    placeholder: 'Enter stream title',
                  ),
                  const SizedBox(height: 24),
                  
                  // 3. Products List Header
                  Text(
                    'Select Products to Feature',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Interactive reactive list of products
                  Obx(() {
                    final products = _controller.storeProducts;
                    // Force Obx to track the selection list by reading it synchronously
                    final selectedList = _controller.selectedProducts.toList();
                    
                    if (products.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No products found in your store. Add products to feature them.',
                          style: TextStyle(
                            fontSize: 13,
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final isSelected = selectedList.any((p) => p.id == product.id);
                        
                        return LiveProductSelectionCard(
                          product: product,
                          isSelected: isSelected,
                          onChanged: (_) => _controller.toggleProductSelection(product),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  
                  // 4. Suggestions advice card
                  const TipsCard(),
                ],
              ),
            ),
          ),
          
          // Persistent Continue Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
