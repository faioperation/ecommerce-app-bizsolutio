import 'package:get/get.dart';
import '../models/profile_user_model.dart';

class ProfileController extends GetxController {
  final user = Rxn<ProfileUserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));

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
