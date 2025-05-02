import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/search/search_result_controller.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/loading_post_item.dart';
import 'package:product_sharing/view/widgets/post_item.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class SearchResultScreen extends StatelessWidget {
  const SearchResultScreen({super.key, required this.keyword});

  final String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SearchResultController>(
        init: SearchResultController(keyword: keyword),
        builder: (controller) => Column(
          children: [
            VerticalSpace(height: DeviceHelper.statusbarHeight(context)),
            Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Image.asset(
                    AppImages.backIcon,
                    height: 16.sp,
                  ),
                ),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    onTap: () => Get.back(),
                    controller: TextEditingController(text: keyword),
                    decoration: const InputDecoration(filled: false),
                  ),
                ),
                const HorizontalSpace(width: 20)
              ],
            ),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? GridView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        padding: EdgeInsets.all(16.sp),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          mainAxisSpacing: 30.sp,
                          crossAxisSpacing: 24.sp,
                        ),
                        itemBuilder: (context, index) =>
                            const LoadingPostItem())
                    : controller.error.value != null
                        ? Center(
                            child: Text(controller.error.value ?? ''),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            controller: controller.scrollController,
                            itemCount: controller.postList.length +
                                (controller.paginationLoading.value ? 2 : 0),
                            padding: EdgeInsets.all(16.sp),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.78,
                              mainAxisSpacing: 30.sp,
                              crossAxisSpacing: 24.sp,
                            ),
                            itemBuilder: (context, index) =>
                                index < controller.postList.length
                                    ? PostItem(
                                        post: controller.postList[index],
                                        onWishlistTap: () {
                                          controller.toggleWishlist(
                                              controller.postList[index]);
                                        },
                                      )
                                    : const LoadingPostItem(),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
