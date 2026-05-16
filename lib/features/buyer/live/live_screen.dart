import 'package:flutter/material.dart';
import '../../../core/widgets/placeholder_screen.dart';
import '../../../core/theme/app_colors.dart';

class BuyerLiveScreen extends StatelessWidget {
  const BuyerLiveScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: "Live Channels", color: AppColors.liveBadge);
}
