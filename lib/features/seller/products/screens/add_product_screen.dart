import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/products_controller.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../widgets/image_picker_section.dart';
import '../widgets/video_picker_section.dart';
import '../widgets/custom_text_input.dart';

class SellerAddProductScreen extends StatefulWidget {
  final SellerProductModel? editProduct;

  const SellerAddProductScreen({super.key, this.editProduct});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _categoryController;
  late TextEditingController _descController;

  final List<String> _selectedImages = [];
  String? _uploadedVideo;

  @override
  void initState() {
    super.initState();
    final p = widget.editProduct;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
        text: p?.price != null ? p!.price.toStringAsFixed(0) : '');
    _stockController =
        TextEditingController(text: p?.stock != null ? p!.stock.toString() : '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _descController = TextEditingController(text: p?.description ?? '');

    if (p != null) {
      _selectedImages.add(p.image);
      if (p.video != null) {
        _uploadedVideo = p.video;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least one product image.'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    final controller = Get.find<SellerProductsController>();
    final isEdit = widget.editProduct != null;

    final newProduct = SellerProductModel(
      id: isEdit ? widget.editProduct!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      stock: int.tryParse(_stockController.text.trim()) ?? 0,
      image: _selectedImages.first,
      description: _descController.text.trim(),
      video: _uploadedVideo,
    );

    bool success = false;
    if (isEdit) {
      success = controller.updateProduct(newProduct);
    } else {
      success = controller.addProduct(newProduct);
    }

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEdit ? 'Product updated successfully!' : 'Product added successfully!'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.editProduct != null;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Product' : 'Add Product',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: isDark ? Colors.white : Colors.black87,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reusable Image Picker Section
                      SellerImagePickerSection(
                        selectedImages: _selectedImages,
                        onImagesChanged: (newImages) {
                          setState(() {
                            _selectedImages.clear();
                            _selectedImages.addAll(newImages);
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Reusable Video Picker Section
                      SellerVideoPickerSection(
                        videoPath: _uploadedVideo,
                        onVideoChanged: (newVideo) {
                          setState(() {
                            _uploadedVideo = newVideo;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Product Name Input
                      SellerCustomTextField(
                        controller: _nameController,
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter product name'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Price & Stock
                      Row(
                        children: [
                          Expanded(
                            child: SellerCustomTextField(
                              controller: _priceController,
                              labelText: 'Price (${AppConstants.currencySymbol})',
                              hintText: '0',
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter price';
                                }
                                if (double.tryParse(val) == null) {
                                  return 'Enter valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SellerCustomTextField(
                              controller: _stockController,
                              labelText: 'Stock',
                              hintText: '0',
                              keyboardType: TextInputType.number,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter stock';
                                }
                                if (int.tryParse(val) == null) {
                                  return 'Enter valid integer';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Category
                      SellerCustomTextField(
                        controller: _categoryController,
                        labelText: 'Category',
                        hintText: 'Enter product category',
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter category'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Description
                      SellerCustomTextField(
                        controller: _descController,
                        labelText: 'Description',
                        hintText: 'Describe your product...',
                        maxLines: 4,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter description'
                            : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // Submit Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E2A) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isEdit ? 'Save Changes' : 'Add Product',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
