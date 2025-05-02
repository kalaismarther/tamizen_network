import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/post/mypost_detail_controller.dart';
import 'package:product_sharing/controller/post/post_detail_controller.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/screens/post/mypost_detail_screen.dart';
import 'package:product_sharing/view/screens/post/post_detail_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class PostItem extends StatelessWidget {
  const PostItem(
      {super.key,
      required this.post,
      this.showInList = false,
      this.onWishlistTap,
      this.type = ''});

  final PostModel post;
  final bool showInList;
  final Function()? onWishlistTap;
  final String type;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      child: SizedBox(
        width: showInList ? 180.sp : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                OnlineImage(
                  link: post.imageUrl,
                  height: 160.sp,
                  width: double.infinity,
                  radius: 16.sp,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: onWishlistTap,
                    icon: Container(
                      padding: EdgeInsets.all(6.sp),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      child: post.isWishlisted
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                if (type.isNotEmpty)
                  Positioned(
                    bottom: 10.sp,
                    left: 10.sp,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 6.sp, horizontal: 12.sp),
                      decoration: BoxDecoration(
                        color: AppTheme.sandal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const VerticalSpace(height: 12),
            Text(
              post.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            const VerticalSpace(height: 10),
            Row(
              children: [
                Image.asset(
                  AppImages.locationIconGrey,
                  height: 12.sp,
                ),
                const HorizontalSpace(width: 4),
                Text(
                  post.city.name,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  AppImages.footerProfile,
                  height: 12.sp,
                ),
                const HorizontalSpace(width: 6),
                Text(
                  post.ownerName,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
