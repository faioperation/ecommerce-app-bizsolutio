import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../routes/app_routes.dart';

/// Controls the Settings screen state.
class SettingsController extends GetxController {
  // ─── Preferences ─────────────────────────────────────────────────────────
  final notificationsEnabled = true.obs;

  bool get isDarkMode {
    try {
      final themeController = Get.find<ThemeController>();
      return themeController.themeMode.value == ThemeMode.dark;
    } catch (_) {
      return false;
    }
  }

  /// Sync with real API → PATCH /api/buyer/preferences
  void toggleNotifications(bool val) => notificationsEnabled.value = val;

  void toggleDarkMode(bool val) {
    try {
      final themeController = Get.find<ThemeController>();
      if (val) {
        themeController.setDarkMode();
      } else {
        themeController.setLightMode();
      }
    } catch (_) {
      Get.snackbar('Theme Error', 'Theme controller not found.');
    }
  }

  // ─── Account Actions ──────────────────────────────────────────────────────
  void editProfile() {
    Get.toNamed(AppRoutes.profileEdit);
  }

  void changePassword() {
    Get.toNamed(AppRoutes.profileChangePassword);
  }

}
