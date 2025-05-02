import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/wishlist/wishlist_controller.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';
import 'package:product_sharing/view/widgets/wishlist_item.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(
      init: WishlistController(),
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
            : controller.error.value != null
                ? Center(
                    child: Text(controller.error.value ?? ''),
                  )
                : controller.wishlistItems.isEmpty
                    ? const Center(
                        child: Text('No posts found in your wishlist'))
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 24.sp),
                        controller: controller.scrollController,
                        itemCount: controller.wishlistItems.length +
                            (controller.paginationLoading.value ? 1 : 0),
                        itemBuilder: (context, index) =>
                            index < controller.wishlistItems.length
                                ? WishlistItem(
                                    post: controller.wishlistItems[index])
                                : const CupertinoActivityIndicator(),
                      ),
      ),
    );
  }
}
