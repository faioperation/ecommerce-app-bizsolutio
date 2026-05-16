import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../routes/app_routes.dart';

class SellerRegistrationScreen1 extends StatelessWidget {
  const SellerRegistrationScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: Theme.of(context).brightness == Brightness.dark
                      ? [const Color(0xFF1F1D2B), const Color(0xFF111019)]
                      : [AppColors.primary, const Color(0xFF4F46E5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: AppSpacing.edgeInsetsAllLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BackButton(color: Colors.white),
                  const SizedBox(height: 40),
                  const Text(
                    'Sell on ShopLive',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Join thousands of successful sellers and grow your business with live commerce.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 60),

                  _buildBenefitItem(
                    icon: Icons.videocam_outlined,
                    title: 'Go Live',
                    description: 'Sell your products in real-time through engaging live streams.',
                  ),
                  _buildBenefitItem(
                    icon: Icons.groups_outlined,
                    title: 'Build Audience',
                    description: 'Connect directly with your customers and build a loyal community.',
                  ),
                  _buildBenefitItem(
                    icon: Icons.payments_outlined,
                    title: 'Earn Money',
                    description: 'Get paid instantly and track your business growth with ease.',
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.push(AppRoutes.sellerRegStep2),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.primary
                            : Colors.white,
                        foregroundColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
                      ),
                      child: const Text('Become Seller', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem({required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
