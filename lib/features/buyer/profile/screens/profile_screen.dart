import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section_header.dart';
import '../../../../routes/app_routes.dart';

class BuyerProfileScreen extends StatelessWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          final user = controller.user.value;
          if (user == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          fontFamily: 'Inter',
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.push(AppRoutes.profileSettings),
                        icon: Icon(
                          Icons.settings_outlined,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A1625) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF2A2535)
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                user.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.name,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user.email,
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _statItem('${user.ordersCount}', 'Orders', isDark),
                            _divider(isDark),
                            _statItem(
                                '${user.wishlistCount}', 'Wishlist', isDark),
                            _divider(isDark),
                            _statItem(
                                '${(user.loyaltyPoints / 1000).toStringAsFixed(1)}K',
                                'Points',
                                isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const ProfileSectionHeader(title: 'My Activity'),
                _menuCard(
                  isDark,
                  children: [
                    ProfileMenuTile(
                      icon: Icons.receipt_long_outlined,
                      iconColor: AppColors.primary,
                      title: 'My Orders',
                      onTap: () => context.push(AppRoutes.profileOrders),
                    ),
                    _separator(isDark),
                    ProfileMenuTile(
                      icon: Icons.favorite_border_rounded,
                      iconColor: AppColors.accentPink,
                      title: 'Wishlist',
                      onTap: () => context.push(AppRoutes.profileWishlist),
                    ),
                    _separator(isDark),
                    ProfileMenuTile(
                      icon: Icons.shopping_cart_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Cart',
                      onTap: () => context.push(AppRoutes.profileCart),
                    ),
                  ],
                ),

                const ProfileSectionHeader(title: 'Account Settings'),
                _menuCard(
                  isDark,
                  children: [
                    ProfileMenuTile(
                      icon: Icons.location_on_outlined,
                      iconColor: AppColors.success,
                      title: 'Addresses',
                      onTap: () => context.push(AppRoutes.checkoutAddress),
                    ),
                    _separator(isDark),
                    ProfileMenuTile(
                      icon: Icons.credit_card_rounded,
                      iconColor: AppColors.primary,
                      title: 'Payment Methods',
                      onTap: () => context.push(AppRoutes.checkoutPayment),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _statItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            fontSize: 12,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isDark) {
    return Container(
      height: 32,
      width: 1,
      color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
    );
  }

  Widget _separator(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
    );
  }

  Widget _menuCard(bool isDark, {required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1625) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
          ),
        ),
        child: Column(children: children),
      ),
    );
  }
}
