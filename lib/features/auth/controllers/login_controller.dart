import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login(BuildContext context, UserRole role) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      isLoading.value = false;

      if (!context.mounted) return;
      Get.find<AuthController>().login(role, context);
    }
  }

  void navigateToRegister(BuildContext context, UserRole role) {
    if (role == UserRole.buyer) {
      context.push(AppRoutes.registerBuyer);
    } else {
      context.push(AppRoutes.registerSeller);
    }
  }

  void navigateToForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
