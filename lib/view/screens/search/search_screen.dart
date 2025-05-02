import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/view/screens/category/category_posts_screen.dart';
import 'package:product_sharing/view/screens/search/search_result_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/controller/search/search_controller.dart'
    as search;
import 'package:product_sharing/view/widgets/vertical_space.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchFocus = FocusNode();
    searchFocus.requestFocus();
    return GetBuilder<search.SearchController>(
      init: search.SearchController(),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'Search'),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Column(
              children: [
                TextField(
                  focusNode: searchFocus,
                  textInputAction: TextInputAction.search,
                  controller: controller.textController,
                  decoration: InputDecoration(
                    filled: false,
                    hintText: 'Search Product',
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.sp),
                      child: Image.asset(
                        AppImages.searchIcon,
                        color: Colors.grey,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(maxHeight: 20.sp),
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      await Get.to(
                          () => SearchResultScreen(keyword: value.trim()));
                    } else {
                      searchFocus.requestFocus();
                    }
                  },
                ),
                const VerticalSpace(height: 8),
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.searchHistoryList.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Recent Search',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    TextButton(
                                      onPressed: controller.clearSearchHistory,
                                      child: const Text(
                                        'Clear all',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemCount:
                                      controller.searchHistoryList.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      controller.textController.text =
                                          controller
                                              .searchHistoryList[index].keyword;
                                      Get.to(() => SearchResultScreen(
                                          keyword:
                                              controller.textController.text));
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.sp),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            AppImages.clockIcon,
                                            height: 16.sp,
                                          ),
                                          const HorizontalSpace(width: 12),
                                          Expanded(
                                              child: Text(controller
                                                  .searchHistoryList[index]
                                                  .keyword)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const VerticalSpace(height: 16),
                              if (controller
                                  .popularCategoryList.isNotEmpty) ...[
                                Text(
                                  'Popular Categories',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const VerticalSpace(height: 8),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemCount:
                                      controller.popularCategoryList.length,
                                  itemBuilder: (context, index) => InkWell(
                                    onTap: () {
                                      Get.to(() => CategoryPostsScreen(
                                            category: controller
                                                .popularCategoryList[index],
                                            fromSearchScreen: true,
                                          ));
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.sp),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(controller
                                                .popularCategoryList[index]
                                                .name),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: 16.sp,
                                          ),
                                          const HorizontalSpace(width: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
