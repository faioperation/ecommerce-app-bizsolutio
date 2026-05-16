import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primary.withValues(alpha: 0.05),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.edgeInsetsAllLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.domain_verification_outlined, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text('Enter 6-Digit OTP', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(
                'We have sent a verification code to your email.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              Center(
                child: Pinput(
                  length: 6,
                  controller: controller.otpController,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  autofocus: true,
                  showCursor: true,
                  onCompleted: (pin) => controller.verifyOtp(context),
                ),
              ),
              
              const SizedBox(height: 48),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.verifyOtp(context),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text('Verify OTP', style: TextStyle(fontSize: 16)),
              )),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {

                },
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
