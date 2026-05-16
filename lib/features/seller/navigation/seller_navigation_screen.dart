import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/animated_nav_item.dart';

class SellerNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SellerNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedNavItem(
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Dashboard',
                  isSelected: navigationShell.currentIndex == 0,
                  onTap: () => _onTap(0),
                ),
                AnimatedNavItem(
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2,
                  label: 'Products',
                  isSelected: navigationShell.currentIndex == 1,
                  onTap: () => _onTap(1),
                ),
                AnimatedNavItem(
                  icon: Icons.videocam_outlined,
                  activeIcon: Icons.videocam,
                  label: 'Live',
                  isSelected: navigationShell.currentIndex == 2,
                  isLiveButton: true,
                  onTap: () => _onTap(2),
                ),
                AnimatedNavItem(
                  icon: Icons.receipt_long_outlined,
                  activeIcon: Icons.receipt_long,
                  label: 'Orders',
                  isSelected: navigationShell.currentIndex == 3,
                  onTap: () => _onTap(3),
                ),
                AnimatedNavItem(
                  icon: Icons.storefront_outlined,
                  activeIcon: Icons.storefront,
                  label: 'Profile',
                  isSelected: navigationShell.currentIndex == 4,
                  onTap: () => _onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
