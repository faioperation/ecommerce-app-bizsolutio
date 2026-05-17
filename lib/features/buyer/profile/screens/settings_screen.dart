import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Preferences ──────────────────────────────────────────────
            const ProfileSectionHeader(title: 'Preferences'),
            _menuCard(
              isDark,
              children: [
                // Notifications Toggle
                Obx(() => _switchTile(
                      isDark: isDark,
                      icon: Icons.notifications_none_outlined,
                      iconColor: AppColors.primary,
                      title: 'Notifications',
                      value: controller.notificationsEnabled.value,
                      onChanged: controller.toggleNotifications,
                    )),
                _separator(isDark),
                // Dark Mode Toggle
                Obx(() => _switchTile(
                      isDark: isDark,
                      icon: Icons.dark_mode_outlined,
                      iconColor: isDark ? Colors.white : Colors.black87,
                      title: 'Dark Mode',
                      value: controller.darkModeEnabled.value,
                      onChanged: controller.toggleDarkMode,
                    )),
                _separator(isDark),
                // Language Selector
                ProfileMenuTile(
                  icon: Icons.language_outlined,
                  iconColor: AppColors.success,
                  title: 'Language',
                  subtitle: controller.selectedLanguage.value,
                  onTap: () => _showLanguagePicker(context, controller, isDark),
                ),
              ],
            ),

            // ── Account ──────────────────────────────────────────────────
            const ProfileSectionHeader(title: 'Account'),
            _menuCard(
              isDark,
              children: [
                ProfileMenuTile(
                  icon: Icons.person_outline,
                  iconColor: AppColors.accentPink,
                  title: 'Edit Profile',
                  onTap: controller.editProfile,
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.lock_outline_rounded,
                  iconColor: AppColors.warning,
                  title: 'Change Password',
                  onTap: controller.changePassword,
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.shield_outlined,
                  iconColor: AppColors.info,
                  title: 'Privacy & Security',
                  onTap: controller.privacyAndSecurity,
                ),
              ],
            ),

            // ── About ────────────────────────────────────────────────────
            const ProfileSectionHeader(title: 'About'),
            _menuCard(
              isDark,
              children: [
                ProfileMenuTile(
                  icon: Icons.description_outlined,
                  iconColor: Colors.grey,
                  title: 'Terms of Service',
                  onTap: controller.termsOfService,
                ),
                _separator(isDark),
                ProfileMenuTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: Colors.grey,
                  title: 'Privacy Policy',
                  onTap: controller.privacyPolicy,
                ),
                _separator(isDark),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.info_outline_rounded,
                            color: isDark ? Colors.white54 : Colors.grey[400],
                            size: 20),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'Version',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '1.0.0',
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
            const SizedBox(height: 40),
          ],
        ),
      ),
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

  Widget _separator(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? const Color(0xFF2A2535) : AppColors.lightBorder,
    );
  }

  Widget _switchTile({
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, SettingsController controller, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1625) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Language',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              ...controller.availableLanguages.map((lang) {
                return ListTile(
                  title: Text(
                    lang,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  trailing: controller.selectedLanguage.value == lang
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () => controller.setLanguage(lang),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
