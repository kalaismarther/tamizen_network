import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/post/mypost_detail_controller.dart';
import 'package:product_sharing/controller/post/post_detail_controller.dart';
import 'package:product_sharing/controller/wishlist/wishlist_controller.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/screens/post/mypost_detail_screen.dart';
import 'package:product_sharing/view/screens/post/post_detail_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class WishlistItem extends StatelessWidget {
  const WishlistItem({super.key, required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WishlistController>();
    return GestureDetector(
      onTap: () async {
        final user = StorageHelper.getUserDetail();

        if (user.id == post.ownerId) {
          Get.delete<MypostDetailController>();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MypostDetailScreen(post: post)));
        } else {
          Get.delete<PostDetailController>();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostDetailScreen(post: post)));
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 16.sp),
        decoration: BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            OnlineImage(
              link: post.imageUrl,
              height: 64.sp,
              width: 64.sp,
              radius: 14.sp,
            ),
            const HorizontalSpace(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.name,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  const VerticalSpace(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        AppImages.locationIconGrey,
                        height: 12.sp,
                      ),
                      const HorizontalSpace(width: 8),
                      Text(
                        post.city.name,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  )
                ],
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
          ],
        ),
      ),
    );
  }
}
