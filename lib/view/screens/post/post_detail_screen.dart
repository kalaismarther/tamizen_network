import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/post/post_detail_controller.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/loading_post_item.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/post_item.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/report_post_dialog.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(
      init: PostDetailController(post: post),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: PrimaryAppbar(
            title: 'Post Detail',
            actions: [
              PopupMenuButton(
                color: Colors.white,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ReportPostDialog(onSubmit: controller.reportPost),
                      );
                    },
                    child: const Text(
                      'Report',
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                              'Do you want to block ${controller.ownerName.value}?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Get.back();
                                controller.blockPost();
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      'Block',
                    ),
                  )
                ],
              )
            ],
          ),
          body: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : controller.error.value != null
                    ? Center(
                        child: Text(controller.error.value ?? ''),
                      )
                    : SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 300.sp,
                                  width: DeviceHelper.screenWidth(context),
                                  child: PageView.builder(
                                    controller: controller.pageController,
                                    itemCount: controller.images.length,
                                    onPageChanged: (index) =>
                                        controller.currentIndex.value = index,
                                    itemBuilder: (context, index) =>
                                        OnlineImage(
                                            link: controller.images[index],
                                            height: double.infinity,
                                            width: DeviceHelper.screenWidth(
                                                context),
                                            radius: 16.sp),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 10,
                                  child: Obx(() => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          controller.images.length,
                                          (index) => Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white60),
                                              color: controller
                                                          .currentIndex.value ==
                                                      index
                                                  ? Colors.white
                                                  : Colors.blueGrey
                                                      .withOpacity(0.36),
                                            ),
                                          ),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            // ConstrainedBox(
                            //   constraints: BoxConstraints(maxHeight: 230.sp),
                            //   child: CarouselView(
                            //     itemExtent: double.infinity,
                            //     padding: const EdgeInsets.all(0),
                            //     itemSnapping: true,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(16.sp),
                            //     ),
                            //     children: controller.images
                            //         .map(
                            //           (banner) => CachedNetworkImage(
                            //             imageUrl: banner,
                            //             placeholder: (context, url) => Container(
                            //               clipBehavior: Clip.hardEdge,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(16),
                            //               ),
                            //               child: const LoadingShimmer(
                            //                 height: double.infinity,
                            //                 width: double.infinity,
                            //                 radius: 8,
                            //               ),
                            //             ),
                            //             imageBuilder: (context, imageProvider) =>
                            //                 Container(
                            //               width: double.infinity,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(16),
                            //                 image: DecorationImage(
                            //                   image: imageProvider,
                            //                   fit: BoxFit.cover,
                            //                 ),
                            //               ),
                            //             ),
                            //             errorWidget: (context, url, error) =>
                            //                 Container(
                            //               clipBehavior: Clip.hardEdge,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(30),
                            //               ),
                            //               child: const Center(
                            //                 child: Icon(Icons.error),
                            //               ),
                            //             ),
                            //           ),
                            //         )
                            //         .toList(),
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const VerticalSpace(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.title.value,
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      if (!controller.activePost.value)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.sp,
                                              horizontal: 12.sp),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius:
                                                BorderRadius.circular(4.sp),
                                          ),
                                          child: Text(
                                            'INACTIVE',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                    ],
                                  ),
                                  const VerticalSpace(height: 10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppImages.locationIconGrey,
                                        height: 14.sp,
                                        color: Colors.blue,
                                      ),
                                      const HorizontalSpace(width: 10),
                                      Text(
                                        controller.cityName.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      const HorizontalSpace(width: 24),
                                      Image.asset(
                                        AppImages.footerProfile,
                                        height: 14.sp,
                                        color: Colors.blue,
                                      ),
                                      const HorizontalSpace(width: 10),
                                      Text(
                                        controller.ownerName.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const VerticalSpace(height: 12),

                                  ExpandableText(
                                    controller.description.value,
                                    expandText: 'more...',
                                    collapseText: '...less',
                                    maxLines: 3,
                                    linkColor: Colors.grey.shade600,
                                    linkStyle: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  const VerticalSpace(height: 12),
                                  Row(
                                    children: [
                                      Text(
                                        'Available : ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      Text(
                                        controller.quantity.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  ),
                                  const VerticalSpace(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.red,
                                    ),
                                    onPressed: controller.showContactDialog,
                                    child: const Text('Contact Owner'),
                                  ),
                                  const VerticalSpace(height: 16),
                                  ElevatedButton(
                                    onPressed: controller.alreadyRequested.value
                                        ? null
                                        : controller.sendRequestToOwner,
                                    child: Text(
                                        controller.alreadyRequested.value
                                            ? 'Requested'
                                            : 'Request'),
                                  ),
                                  const VerticalSpace(height: 30),
                                  //SIMILAR POSTS
                                  Row(
                                    children: [
                                      Text(
                                        'Similar Posts',
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      // const HorizontalSpace(width: 6),
                                      // Text(
                                      //   '15+',
                                      //   style: TextStyle(
                                      //       fontSize: 14.sp,
                                      //       fontWeight: FontWeight.w500,
                                      //       color: Colors.grey),
                                      // ),
                                      // const Spacer(),
                                      // TextButton(
                                      //   onPressed: () {},
                                      //   child: const Text('See All'),
                                      // )
                                    ],
                                  ),
                                  const VerticalSpace(height: 8),
                                  controller.similarPostLoading.value
                                      ? GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 6,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.78,
                                            mainAxisSpacing: 30.sp,
                                            crossAxisSpacing: 24.sp,
                                          ),
                                          itemBuilder: (context, index) =>
                                              const LoadingPostItem(),
                                        )
                                      : GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: controller
                                                  .similarPostList.length +
                                              (controller
                                                      .paginationLoading.value
                                                  ? 2
                                                  : 0),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.78,
                                            mainAxisSpacing: 30.sp,
                                            crossAxisSpacing: 24.sp,
                                          ),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                controller
                                                    .similarPostList.length) {
                                              return PostItem(
                                                post: controller
                                                    .similarPostList[index],
                                                onTap: () async {
                                                  Get.delete<
                                                      PostDetailController>();
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PostDetailScreen(
                                                                  post: post)));

                                                  controller.onInit();
                                                },
                                                onWishlistTap: () {
                                                  controller.toggleWishlist(
                                                      controller
                                                              .similarPostList[
                                                          index]);
                                                },
                                              );
                                            } else {
                                              return const LoadingPostItem();
                                            }
                                          }),

                                  const VerticalSpace(height: 16),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
