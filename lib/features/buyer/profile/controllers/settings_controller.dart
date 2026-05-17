import 'package:get/get.dart';

/// Controls the Settings screen state.
/// Each setting maps directly to a future API preference endpoint.
class SettingsController extends GetxController {
  // ─── Preferences ─────────────────────────────────────────────────────────
  final notificationsEnabled = true.obs;
  final darkModeEnabled = false.obs;
  final selectedLanguage = 'English'.obs;

  final List<String> availableLanguages = [
    'English',
    'Bengali',
    'Arabic',
    'French',
    'Spanish',
  ];

  /// TODO: Sync with real API → PATCH /api/buyer/preferences
  void toggleNotifications(bool val) => notificationsEnabled.value = val;

  void toggleDarkMode(bool val) {
    darkModeEnabled.value = val;
    // TODO: Apply theme change via ThemeController
  }

  void setLanguage(String lang) {
    selectedLanguage.value = lang;
    Get.back();
  }

  // ─── Account Actions ──────────────────────────────────────────────────────
  void editProfile() {
    // TODO: Navigate to edit profile screen
    Get.snackbar('Edit Profile', 'Coming soon!');
  }

  void changePassword() {
    // TODO: Navigate to change password screen
    Get.snackbar('Change Password', 'Coming soon!');
  }

  void privacyAndSecurity() {
    Get.snackbar('Privacy & Security', 'Coming soon!');
  }

  void termsOfService() {
    Get.snackbar('Terms of Service', 'Coming soon!');
  }

  void privacyPolicy() {
    Get.snackbar('Privacy Policy', 'Coming soon!');
  }
}
