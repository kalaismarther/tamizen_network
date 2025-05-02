import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/auth/change_password_controller.dart';
import 'package:product_sharing/view/widgets/gradient_button.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());
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
                    'Change Password',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const VerticalSpace(height: 48),
                  Obx(
                    () => TextField(
                      obscureText: controller.hidePassword.value,
                      onChanged: (value) =>
                          controller.password.value = value.trim(),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.hidePassword.value =
                                !controller.hidePassword.value;
                          },
                          icon: Image.asset(AppImages.eyeIcon),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 28.sp),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Obx(
                    () => TextField(
                      obscureText: controller.hideConfirmPassword.value,
                      onChanged: (value) =>
                          controller.confirmPassword.value = value.trim(),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.hideConfirmPassword.value =
                                !controller.hideConfirmPassword.value;
                          },
                          icon: Image.asset(AppImages.eyeIcon),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 28.sp),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 30),
                  GradientButton(
                      onPressed: controller.changePassword, text: 'Submit'),
                  const VerticalSpace(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
