import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/auth/verification_controller.dart';
import 'package:product_sharing/view/widgets/gradient_button.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController(type: type));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 320.sp,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppImages.loginBanner), fit: BoxFit.fill),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.logoWhite,
                  height: 130.sp,
                ),
              ),
            ),
            const VerticalSpace(height: 10),
            Padding(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                children: [
                  Text(
                    'Verification',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const VerticalSpace(height: 24),
                  Text(
                    'OTP sent to your Email Address',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 40.sp),
                  Pinput(
                    length: 4,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onChanged: (value) => controller.otp.value = value.trim(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    defaultPinTheme: PinTheme(
                      width: 64.sp,
                      height: 62.sp,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: AppTheme.inputBg,
                        border: Border.all(
                          width: 1.5,
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 64.sp,
                      height: 62.sp,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    errorPinTheme: PinTheme(
                      width: 64.sp,
                      height: 62.sp,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.error),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontSize: 20.sp,
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.sp),
                  Center(
                    child: Obx(
                      () {
                        if (controller.remainingSeconds.value == 0) {
                          return TextButton(
                            onPressed: () {
                              controller.resetTimer();
                            },
                            child: Text(
                              'Resend',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppTheme.darkBlue),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Re-send code in'),
                                const SizedBox(width: 4),
                                Text(
                                  '${controller.remainingSeconds.value} secs',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const VerticalSpace(height: 40),
                  GradientButton(
                      onPressed: controller.verifyOtp, text: 'Verify OTP')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
