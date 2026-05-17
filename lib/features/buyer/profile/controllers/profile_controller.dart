import 'package:get/get.dart';
import '../models/profile_user_model.dart';

/// Controls the main Profile screen state.
/// Replace mock data with real API calls when ready.
class ProfileController extends GetxController {
  // ─── User Data ────────────────────────────────────────────────────────────
  final user = Rxn<ProfileUserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// TODO: Replace with real API call → GET /api/buyer/profile
  Future<void> loadProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300)); // simulated delay

    user.value = ProfileUserModel(
      id: 'usr_001',
      name: 'John Doe',
      email: 'john.doe@email.com',
      ordersCount: 45,
      wishlistCount: 12,
      loyaltyPoints: 2400,
    );

    isLoading.value = false;
  }
}
