import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/post/mypost_detail_controller.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/screens/post/edit_post_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/requested_customer_item.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class MypostDetailScreen extends StatelessWidget {
  const MypostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MypostDetailController>(
      init: MypostDetailController(post: post),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: PrimaryAppbar(
            title: 'Post Detail',
            actions: controller.showActionIcons.value
                ? [
                    IconButton(
                      onPressed: () async {
                        await Get.to(() => EditPostScreen(post: post));
                        await controller.getMyPostDetail();
                      },
                      icon: Image.asset(
                        AppImages.editIcon,
                        height: 20.sp,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.showDeleteAlert(post);
                      },
                      icon: Image.asset(
                        AppImages.deleteIcon,
                        height: 24.sp,
                      ),
                    ),
                    const HorizontalSpace(width: 8)
                  ]
                : null,
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
                                  const VerticalSpace(height: 10),
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: EdgeInsets.all(16.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Requested Customers',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const VerticalSpace(height: 10),
                                  if (controller
                                      .requestedCustomersLoading.value)
                                    const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  else if (controller
                                          .requestedCustomerListError.value !=
                                      null)
                                    Center(
                                      child: Text(controller
                                              .requestedCustomerListError
                                              .value ??
                                          ''),
                                    )
                                  else if (controller
                                      .requestedCustomerList.isEmpty)
                                    const Center(
                                      child: Text('No customers found'),
                                    )
                                  else
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.all(0),
                                      itemCount: controller
                                              .requestedCustomerList.length +
                                          (controller.paginationLoading.value
                                              ? 1
                                              : 0),
                                      itemBuilder: (context, index) => index <
                                              controller
                                                  .requestedCustomerList.length
                                          ? RequestedCustomerItem(
                                              customer: controller
                                                  .requestedCustomerList[index])
                                          : const Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            ),
                                    )
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
