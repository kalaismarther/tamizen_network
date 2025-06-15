import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/auth/signup_controller.dart';
import 'package:product_sharing/view/screens/faq/policy_screen.dart';
import 'package:product_sharing/view/widgets/gradient_button.dart';
import 'package:product_sharing/view/widgets/gradient_text.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
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
                    'Sign Up',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const VerticalSpace(height: 40),
                  TextField(
                    onChanged: (value) => controller.name.value = value.trim(),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  TextField(
                    onChanged: (value) =>
                        controller.mobileNumber.value = value.trim(),
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Mobile Number',
                      counterText: '',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  TextField(
                    onChanged: (value) =>
                        controller.emailAddress.value = value.trim(),
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  const VerticalSpace(height: 20),
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
                          icon: Padding(
                            padding: EdgeInsets.all(6.sp),
                            child: Image.asset(AppImages.eyeIcon),
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 28.sp),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Obx(
                    () => TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: controller.selectedCity.value?.name ?? ''),
                      onTap: () {
                        controller.searchCity.value = '';
                        controller.getCities();
                        Get.bottomSheet(
                          Container(
                            padding: EdgeInsets.all(16.sp),
                            height: 400.sp,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  onChanged: (value) {
                                    controller.searchCity.value = value.trim();
                                    controller.getCities();
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.sp),
                                      child: Image.asset(
                                        AppImages.searchIcon,
                                        color: Colors.grey,
                                        height: 20.sp,
                                      ),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(maxHeight: 24.sp),
                                  ),
                                ),
                                Obx(
                                  () => Expanded(
                                    child: controller.citiesLoading.value
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : controller.cityListError.value != null
                                            ? Center(
                                                child: Text(controller
                                                    .cityListError.value!),
                                              )
                                            : ListView.builder(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.sp),
                                                itemCount:
                                                    controller.cityList.length,
                                                itemBuilder: (context, index) =>
                                                    InkWell(
                                                  onTap: () {
                                                    controller.selectedCity
                                                            .value =
                                                        controller
                                                            .cityList[index];
                                                    Get.back();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.sp),
                                                    child: Text(
                                                      controller
                                                          .cityList[index].name
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 16.sp),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'City',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: Image.asset(
                              AppImages.searchIcon,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(maxHeight: 36.sp),
                      ),
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  Obx(
                    () => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 24.sp,
                          child: Checkbox(
                            value: controller.agreedToTerms.value,
                            onChanged: (value) =>
                                controller.agreedToTerms.value = value!,
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black, height: 1.4.sp),
                              children: [
                                TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                                TextSpan(
                                  text: "Terms & Conditions",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => Get.to(() => const PolicyScreen(
                                              type: 'TERM_POLICY',
                                            )),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap =
                                        () => Get.to(() => const PolicyScreen(
                                              type: 'PRIVACY_POLICY',
                                            )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpace(height: 20),
                  GradientButton(onPressed: controller.signUp, text: 'Sign Up'),
                  const VerticalSpace(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: GradientText(
                          text: 'Login',
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
