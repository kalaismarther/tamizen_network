import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/faq/policy_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key, required this.type});

  final String type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.blue,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Image.asset(
            AppImages.backIcon,
            height: 16.sp,
            color: Colors.white,
          ),
        ),
        title: Text(
          type == 'TERM_POLICY' ? 'Terms and Conditions' : 'Privacy Policy',
          style: TextStyle(fontSize: 20.sp, color: Colors.white),
        ),
      ),
      body: GetBuilder<PolicyController>(
        init: PolicyController(type: type),
        builder: (controller) => Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.error.value != null) {
              return Center(
                child: Text(controller.error.value ?? ''),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: HtmlWidget(controller.content.value),
            );
          },
        ),
      ),
    );
  }
}
