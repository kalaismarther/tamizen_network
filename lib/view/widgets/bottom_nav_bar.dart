import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/core/utils/device_helper.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return Obx(
      () => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 70),
            painter: BNBCustomPainter(),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 70,
              width: DeviceHelper.screenWidth(context),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(context, AppImages.footerHome, 'HOME', 0,
                      controller.currentTab.value == 0),
                  _navItem(context, AppImages.footerWishlist, 'WISHLIST', 1,
                      controller.currentTab.value == 1),
                  SizedBox(height: 80.sp),
                  _navItem(context, AppImages.footerMypost, 'MY POST', 3,
                      controller.currentTab.value == 3),
                  _navItem(context, AppImages.footerProfile, 'PROFILE', 4,
                      controller.currentTab.value == 4),
                ],
              ),
            ),
          ),
          Positioned(
            top: -20.sp,
            child: GestureDetector(
              onTap: () {
                controller.changeTab(2);
              },
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  AppImages.footerPost,
                  height: 64.sp,
                  width: 64.sp,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String image, String label, int index,
          bool activeIndex) =>
      InkWell(
        onTap: () {
          final controller = Get.find<DashboardController>();
          controller.changeTab(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              color: activeIndex ? AppTheme.blue : null,
              height: 24.sp,
            ),
            SizedBox(height: 4.sp),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12.sp, color: activeIndex ? AppTheme.blue : null),
            )
          ],
        ),
      );
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 20);

    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.40, 0);
    path.quadraticBezierTo(size.width * 0.50, 50, size.width * 0.60, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black12, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
