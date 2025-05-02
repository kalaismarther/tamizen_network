import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/controller/profile/profile_controller.dart';
import 'package:product_sharing/view/screens/chat/chat_list_screen.dart';
import 'package:product_sharing/view/screens/faq/faq_screen.dart';
import 'package:product_sharing/view/screens/notification/notification_screen.dart';
import 'package:product_sharing/view/screens/profile/edit_profile_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/profile_menu_item.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    final dashboardController = Get.find<DashboardController>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        children: [
          Obx(
            () => Container(
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    spreadRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  OnlineImage(
                    link: controller.userDp.value,
                    height: 72.sp,
                    width: 72.sp,
                    radius: 10.sp,
                  ),
                  const HorizontalSpace(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userName.value,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                        const VerticalSpace(height: 4),
                        Text(
                          controller.email.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Get.to(() => const EditProfileScreen());
                      controller.onInit();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 6.sp, horizontal: 20.sp),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.blue, width: 1),
                        borderRadius: BorderRadius.circular(8.sp),
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.blue,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const VerticalSpace(height: 30),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 1.2),
              borderRadius: BorderRadius.circular(12.sp),
            ),
            child: Column(
              children: [
                ProfileMenuItem(
                  onTap: () => dashboardController.changeTab(0),
                  image: AppImages.menuHome,
                  text: 'Home',
                ),
                ProfileMenuItem(
                  onTap: () => dashboardController.changeTab(2),
                  image: AppImages.menuNewPost,
                  text: 'Add Post',
                ),
                ProfileMenuItem(
                  onTap: () => dashboardController.changeTab(3),
                  image: AppImages.menuMyPost,
                  text: 'My Post',
                ),
                ProfileMenuItem(
                  onTap: () => Get.to(() => const ChatListScreen()),
                  image: AppImages.chat,
                  text: 'Chat',
                ),
                ProfileMenuItem(
                  onTap: () => Get.to(() => const NotificationScreen()),
                  image: AppImages.menuNotification,
                  text: 'Notification',
                ),
                ProfileMenuItem(
                  onTap: () => Get.to(() => const FaqScreen()),
                  image: AppImages.menuHelp,
                  text: 'Help & Support',
                ),
                ProfileMenuItem(
                  onTap: controller.showLogoutAlert,
                  image: AppImages.logout,
                  text: 'Logout',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
