import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/controller/home/home_controller.dart';
import 'package:product_sharing/controller/post/post_detail_controller.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/view/screens/category/category_list_screen.dart';
import 'package:product_sharing/view/screens/category/category_posts_screen.dart';
import 'package:product_sharing/view/screens/notification/notification_screen.dart';
import 'package:product_sharing/view/screens/post/post_detail_screen.dart';
import 'package:product_sharing/view/screens/post/see_all_post_screen.dart';
import 'package:product_sharing/view/screens/profile/edit_profile_screen.dart';
import 'package:product_sharing/view/screens/search/search_screen.dart';
import 'package:product_sharing/view/widgets/category_item.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/loading_post_item.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/post_item.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => SafeArea(
        bottom: true,
        top: false,
        child: Container(
          padding: EdgeInsets.only(top: DeviceHelper.statusbarHeight(context)),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final dashboardController =
                              Get.find<DashboardController>();

                          dashboardController.changeTab(4);
                        },
                        child: OnlineImage(
                          link: controller.userDp.value,
                          height: 50.sp,
                          width: 50.sp,
                          radius: 0,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const HorizontalSpace(width: 10),
                      Text(
                        'Hi, ${controller.userName.value} !',
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Get.to(() => const SearchScreen()),
                        icon: Image.asset(
                          AppImages.search,
                          height: 36.sp,
                        ),
                      ),
                      Obx(
                        () => IconButton(
                          onPressed: () =>
                              Get.to(() => const NotificationScreen()),
                          icon: controller.notificationCount.value == 0
                              ? Image.asset(
                                  AppImages.notification,
                                  height: 36.sp,
                                )
                              : Badge.count(
                                  count: controller.notificationCount.value,
                                  child: Image.asset(
                                    AppImages.notification,
                                    height: 36.sp,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(
                () => TextButton(
                  onPressed: () async {
                    await Get.to(() => const EditProfileScreen());
                    await controller.getUserDetail();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.locationIconWhite,
                        height: 20.sp,
                      ),
                      const HorizontalSpace(width: 6),
                      Text(
                        controller.userCity.value,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Image.asset(
                        AppImages.arrowDownWhite,
                        height: 20.sp,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(const Duration(seconds: 2),
                          controller.loadHomeContent);
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.sp, vertical: 8.sp),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Browse Categories',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const HorizontalSpace(width: 6),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const CategoryListScreen(
                                        chooseCategory: false,
                                      ));
                                },
                                child: const Text('See All'),
                              )
                            ],
                          ),
                          const VerticalSpace(height: 8),
                          Obx(
                            () => controller.categoriesLoading.value
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 10,
                                    padding: const EdgeInsets.all(0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 0.68,
                                      mainAxisSpacing: 20.sp,
                                      crossAxisSpacing: 20.sp,
                                    ),
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        LoadingShimmer(
                                          height: 54.sp,
                                          width: 54.sp,
                                          radius: 0,
                                          shape: BoxShape.circle,
                                        ),
                                        const VerticalSpace(height: 10),
                                        LoadingShimmer(
                                          height: 10.sp,
                                          width: 50.sp,
                                          radius: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.categoryList.length,
                                    padding: const EdgeInsets.all(0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      childAspectRatio: 0.68,
                                      mainAxisSpacing: 20.sp,
                                      crossAxisSpacing: 20.sp,
                                    ),
                                    itemBuilder: (context, index) =>
                                        CategoryItem(
                                      category: controller.categoryList[index],
                                      onTap: () => Get.to(() =>
                                          CategoryPostsScreen(
                                              category: controller
                                                  .categoryList[index])),
                                    ),
                                  ),
                          ),
                          const VerticalSpace(height: 16),

                          //LATEST POSTS
                          Row(
                            children: [
                              Text(
                                'Latest Posts',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const HorizontalSpace(width: 6),
                              const Spacer(),
                              TextButton(
                                onPressed: () => Get.to(
                                    () => const SeeAllPostScreen(type: '1')),
                                child: const Text('See All'),
                              )
                            ],
                          ),
                          const VerticalSpace(height: 8),

                          SizedBox(
                            height: 224.sp,
                            child: Obx(() {
                              if (controller.latestPostsLoading.value) {
                                return ListView.separated(
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    separatorBuilder: (context, index) =>
                                        const HorizontalSpace(width: 20),
                                    itemBuilder: (context, index) =>
                                        const LoadingPostItem(
                                          showInList: true,
                                        ));
                              }

                              if (controller.latestPostListError.value !=
                                  null) {
                                return Center(
                                  child: Text(
                                      controller.latestPostListError.value ??
                                          'Something went wrong'),
                                );
                              }

                              if (controller.latestPostList.isEmpty) {
                                return const Center(
                                  child: Text('No latest post found'),
                                );
                              }

                              return ListView.separated(
                                itemCount: controller.latestPostList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) =>
                                    const HorizontalSpace(width: 20),
                                itemBuilder: (context, index) => PostItem(
                                  post: controller.latestPostList[index],
                                  showInList: true,
                                  onTap: () async {
                                    Get.delete<PostDetailController>();
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailScreen(
                                                    post: controller
                                                            .latestPostList[
                                                        index])));
                                    controller.loadHomeContent();
                                  },
                                  onWishlistTap: () {
                                    controller.toggleWishlist(
                                        controller.latestPostList[index]);
                                  },
                                  type: 'Newest',
                                ),
                              );
                            }),
                          ),

                          const VerticalSpace(height: 16),

                          //POPULAR POSTS
                          Row(
                            children: [
                              Text(
                                'Popular Posts',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const HorizontalSpace(width: 6),
                              const Spacer(),
                              TextButton(
                                onPressed: () => Get.to(
                                    () => const SeeAllPostScreen(type: '2')),
                                child: const Text('See All'),
                              )
                            ],
                          ),
                          const VerticalSpace(height: 8),
                          Obx(() {
                            if (controller.popularPostsLoading.value) {
                              return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 2,
                                  padding: const EdgeInsets.all(0),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.78,
                                    mainAxisSpacing: 30.sp,
                                    crossAxisSpacing: 24.sp,
                                  ),
                                  itemBuilder: (context, index) =>
                                      const LoadingPostItem());
                            }

                            if (controller.popularPostListError.value != null) {
                              return Center(
                                child: Text(
                                    controller.popularPostListError.value ??
                                        'Something went wrong'),
                              );
                            }

                            if (controller.popularPostList.isEmpty) {
                              return const Center(
                                child: Text('No popular post found'),
                              );
                            }

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.popularPostList.length,
                              padding: const EdgeInsets.all(0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.78,
                                mainAxisSpacing: 30.sp,
                                crossAxisSpacing: 24.sp,
                              ),
                              itemBuilder: (context, index) => PostItem(
                                post: controller.popularPostList[index],
                                onTap: () async {
                                  Get.delete<PostDetailController>();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetailScreen(
                                                  post: controller
                                                          .popularPostList[
                                                      index])));
                                  controller.loadHomeContent();
                                },
                                onWishlistTap: () {
                                  controller.toggleWishlist(
                                      controller.popularPostList[index]);
                                },
                                type: 'Popular',
                              ),
                            );
                          }),
                          const VerticalSpace(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
