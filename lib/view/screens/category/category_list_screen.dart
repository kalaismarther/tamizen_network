import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/category/category_list_controller.dart';
import 'package:product_sharing/view/screens/category/category_posts_screen.dart';
import 'package:product_sharing/view/widgets/category_item.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key, required this.chooseCategory});

  final bool chooseCategory;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryListController>(
      init: CategoryListController(chooseCategory: chooseCategory),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'All Categories'),
        body: Obx(
          () => controller.isLoading.value
              ? ListView.builder(
                  padding: EdgeInsets.all(16.sp),
                  itemCount: 10,
                  itemBuilder: (context, index) => ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    leading: LoadingShimmer(
                      height: 48.sp,
                      width: 48.sp,
                      radius: 0,
                      shape: BoxShape.circle,
                    ),
                    title: LoadingShimmer(
                      height: 20.sp,
                      width: 50.sp,
                      radius: 8,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Popular',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.popularCategoryList.length,
                        itemBuilder: (context, index) => CategoryItem(
                          category: controller.popularCategoryList[index],
                          listView: true,
                          onTap: () {
                            if (chooseCategory) {
                              Get.back(
                                  result:
                                      controller.popularCategoryList[index]);
                            } else {
                              Get.to(() => CategoryPostsScreen(
                                  category:
                                      controller.popularCategoryList[index]));
                            }
                          },
                        ),
                      ),
                      const VerticalSpace(height: 24),
                      Text(
                        'Other',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                      const VerticalSpace(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.otherCategoryList.length,
                        itemBuilder: (context, index) => CategoryItem(
                          category: controller.otherCategoryList[index],
                          listView: true,
                          onTap: () {
                            if (chooseCategory) {
                              Get.back(
                                  result: controller.otherCategoryList[index]);
                            } else {
                              Get.to(() => CategoryPostsScreen(
                                  category:
                                      controller.otherCategoryList[index]));
                            }
                          },
                        ),
                      ),
                      if (controller.paginationLoading.value)
                        const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
