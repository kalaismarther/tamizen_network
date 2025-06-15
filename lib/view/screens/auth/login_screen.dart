import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/auth/login_controller.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/view/screens/auth/forgot_password_screen.dart';
import 'package:product_sharing/view/screens/auth/signup_screen.dart';
import 'package:product_sharing/view/widgets/gradient_button.dart';
import 'package:product_sharing/view/widgets/gradient_text.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
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
                    'Login',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const VerticalSpace(height: 40),
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.r),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  TextField(
                    controller: controller.passwordController,
                    obscureText: controller.hidePassword.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(7.sp),
                        child: IconButton(
                          onPressed: () {
                            controller.hidePassword.value =
                                !controller.hidePassword.value;
                          },
                          icon: Image.asset(
                            AppImages.eyeIcon,
                          ),
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(maxHeight: 28.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        UiHelper.unfocus();
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  GradientButton(onPressed: controller.login, text: 'Login'),
                  const VerticalSpace(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('New User?'),
                      TextButton(
                        onPressed: () {
                          UiHelper.unfocus();
                          Get.to(() => const SignupScreen());
                        },
                        child: GradientText(
                          text: 'Sign Up',
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
