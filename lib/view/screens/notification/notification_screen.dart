import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/notification/notification_controller.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/notification_item.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppbar(title: 'Notification'),
      body: GetBuilder<NotificationController>(
        init: NotificationController(),
        builder: (controller) => Obx(
          () {
            if (controller.isLoading.value) {
              return ListView.separated(
                controller: controller.scrollController,
                padding: EdgeInsets.all(16.sp),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const VerticalSpace(height: 20),
                itemBuilder: (context, index) => LoadingShimmer(
                    height: 90.sp, width: double.infinity, radius: 12),
              );
            }

            if (controller.error.value != null) {
              return Center(
                child: Text(controller.error.value ?? ''),
              );
            }

            return ListView.separated(
              controller: controller.scrollController,
              itemCount: controller.notificationList.length +
                  (controller.paginationLoading.value ? 1 : 0),
              separatorBuilder: (context, index) =>
                  const VerticalSpace(height: 24),
              padding: EdgeInsets.all(16.sp),
              itemBuilder: (context, index) =>
                  index < controller.notificationList.length
                      ? NotificationItem(
                          notification: controller.notificationList[0],
                        )
                      : const CupertinoActivityIndicator(),
            );
          },
        ),
      ),
    );
  }
}
