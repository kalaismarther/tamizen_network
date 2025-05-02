import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/controller/post/mypost_list_controller.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/mypost_item.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class MypostListScreen extends StatelessWidget {
  const MypostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MypostListController>(
      init: MypostListController(),
      builder: (controller) => Obx(
        () => controller.isLoading.value
            ? ListView.separated(
                controller: controller.scrollController,
                padding: EdgeInsets.all(16.sp),
                itemCount: 5,
                separatorBuilder: (context, index) =>
                    const VerticalSpace(height: 20),
                itemBuilder: (context, index) => LoadingShimmer(
                    height: 90.sp, width: double.infinity, radius: 12),
              )
            : controller.mypostList.isEmpty
                ? Center(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final dashboardController =
                            Get.find<DashboardController>();
                        dashboardController.changeTab(2);
                      },
                      label: const Text('Add New Post'),
                      icon: const Icon(Icons.add),
                    ),
                  )
                : controller.error.value != null
                    ? Center(
                        child: Text(controller.error.value ?? ''),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 24.sp),
                        controller: controller.scrollController,
                        itemCount: controller.mypostList.length +
                            (controller.paginationLoading.value ? 1 : 0),
                        itemBuilder: (context, index) =>
                            index < controller.mypostList.length
                                ? MypostItem(
                                    post: controller.mypostList[index],
                                  )
                                : const CupertinoActivityIndicator(),
                      ),
      ),
    );
  }
}
