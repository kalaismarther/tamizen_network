import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/post/post_detail_controller.dart';
import 'package:product_sharing/controller/post/see_all_post_controller.dart';
import 'package:product_sharing/view/screens/post/post_detail_screen.dart';
import 'package:product_sharing/view/widgets/loading_post_item.dart';
import 'package:product_sharing/view/widgets/post_item.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';

class SeeAllPostScreen extends StatelessWidget {
  const SeeAllPostScreen({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SeeAllPostController>(
      init: SeeAllPostController(type: type),
      builder: (controller) => Scaffold(
        body: Scaffold(
          appBar: PrimaryAppbar(
              title: type == '1' ? 'Latest Posts' : 'Popular Posts'),
          body: Obx(
            () => controller.isLoading.value
                ? GridView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    padding: EdgeInsets.all(16.sp),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 30.sp,
                      crossAxisSpacing: 24.sp,
                    ),
                    itemBuilder: (context, index) => const LoadingPostItem())
                : GridView.builder(
                    shrinkWrap: true,
                    controller: controller.scrollController,
                    itemCount: controller.allPostList.length +
                        (controller.paginationLoading.value ? 2 : 0),
                    padding: EdgeInsets.all(16.sp),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 30.sp,
                      crossAxisSpacing: 24.sp,
                    ),
                    itemBuilder: (context, index) => index <
                            controller.allPostList.length
                        ? PostItem(
                            post: controller.allPostList[index],
                            type: type == '1' ? 'Newest' : 'Popular',
                            onWishlistTap: () => controller
                                .toggleWishlist(controller.allPostList[index]),
                            onTap: () async {
                              Get.delete<PostDetailController>();
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostDetailScreen(
                                          post:
                                              controller.allPostList[index])));
                              controller.onInit();
                            },
                          )
                        : const LoadingPostItem(),
                  ),
          ),
        ),
      ),
    );
  }
}
