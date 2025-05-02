import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/category/category_posts_controller.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/view/screens/search/search_screen.dart';
import 'package:product_sharing/view/widgets/loading_post_item.dart';
import 'package:product_sharing/view/widgets/post_item.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';

class CategoryPostsScreen extends StatelessWidget {
  const CategoryPostsScreen(
      {super.key, required this.category, this.fromSearchScreen = false});

  final CategoryModel category;
  final bool fromSearchScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(
        title: category.name,
        actions: [
          IconButton(
            onPressed: () {
              if (fromSearchScreen) {
                Get.back();
              } else {
                Get.to(() => const SearchScreen());
              }
            },
            icon: Image.asset(
              AppImages.search,
              height: 36.sp,
            ),
          ),
        ],
      ),
      body: GetBuilder<CategoryPostsController>(
        init: CategoryPostsController(category: category),
        builder: (controller) => Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.sp),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintText: 'Search posts in ${category.name}',
            //       suffixIcon: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 12.sp),
            //         child: Image.asset(
            //           AppImages.searchIcon,
            //           color: Colors.grey,
            //         ),
            //       ),
            //       suffixIconConstraints: BoxConstraints(maxHeight: 20.sp),
            //     ),
            //     onChanged: (value) {
            //       controller.searchKeyword.value = value.trim();
            //     },
            //     onEditingComplete: () {
            //       UiHelper.unfocus();
            //       controller.pageNo = 0;
            //       controller.isLoading.value = true;
            //       controller.getCategoryPosts();
            //     },
            //     onTapOutside: (event) => UiHelper.unfocus(),
            //   ),
            // ),
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
                            itemCount: controller.categoryPostList.length +
                                (controller.paginationLoading.value ? 2 : 0),
                            padding: EdgeInsets.all(16.sp),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.78,
                              mainAxisSpacing: 30.sp,
                              crossAxisSpacing: 24.sp,
                            ),
                            itemBuilder: (context, index) => index <
                                    controller.categoryPostList.length
                                ? PostItem(
                                    post: controller.categoryPostList[index],
                                    onWishlistTap: () {
                                      controller.toggleWishlist(
                                          controller.categoryPostList[index]);
                                    },
                                  )
                                : const LoadingPostItem(),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
