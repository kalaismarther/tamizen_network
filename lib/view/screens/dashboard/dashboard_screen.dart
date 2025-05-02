import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/view/screens/home/home_screen.dart';
import 'package:product_sharing/view/screens/post/add_post_screen.dart';
import 'package:product_sharing/view/screens/post/mypost_list_screen.dart';
import 'package:product_sharing/view/screens/profile/profile_screen.dart';
import 'package:product_sharing/view/screens/wishlist/wishlist_screen.dart';
import 'package:product_sharing/view/widgets/bottom_nav_bar.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          } else {
            if (controller.currentTab.value == 0) {
              controller.exitAlert();
            } else {
              controller.changeTab(0);
            }
            return;
          }
        },
        child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: controller.currentTab.value == 0
                ? null
                : PrimaryAppbar(
                    title: controller.currentTab.value == 1
                        ? 'Wishlist'
                        : controller.currentTab.value == 2
                            ? 'Add Post'
                            : controller.currentTab.value == 3
                                ? 'My Post'
                                : 'Profile',
                    dashboardScreen: true,
                  ),
            body: controller.currentTab.value == 0
                ? const HomeScreen()
                : controller.currentTab.value == 1
                    ? const WishlistScreen()
                    : controller.currentTab.value == 2
                        ? const AddPostScreen()
                        : controller.currentTab.value == 3
                            ? const MypostListScreen()
                            : const ProfileScreen(),
            bottomNavigationBar: const BottomNavBar(),
          ),
        ),
      ),
    );
  }
}
