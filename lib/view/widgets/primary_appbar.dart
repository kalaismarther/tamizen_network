import 'package:product_sharing/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppbar(
      {super.key,
      required this.title,
      this.actions,
      this.leading,
      this.dashboardScreen = false});

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool dashboardScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 62.sp,
      title: Text(
        title,
        style: TextStyle(fontSize: 20.sp),
      ),
      leading: leading ??
          IconButton(
            onPressed: () {
              if (dashboardScreen) {
                Get.find<DashboardController>().changeTab(0);
              } else {
                Get.back();
              }
            },
            icon: Image.asset(
              AppImages.backIcon,
              height: 16.sp,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.sp);
}
