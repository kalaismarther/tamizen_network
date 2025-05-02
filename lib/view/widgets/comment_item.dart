import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/model/chat/comment_model.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment, required this.onDelete});

  final CommentModel comment;

  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        border: BorderDirectional(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: OnlineImage(
              link: comment.creatorImage,
              height: 36.sp,
              width: 36.sp,
              radius: 0,
              shape: BoxShape.circle,
            ),
            title: Text(
              comment.creatorName,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalSpace(height: 4),
                Text(
                  comment.createdTime,
                  style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                ),
                const VerticalSpace(height: 4),
                Text(
                  comment.content,
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            trailing: comment.byMe
                ? PopupMenuButton(
                    color: Colors.white,
                    icon: Image.asset(
                      AppImages.chatMenu,
                      height: 16.sp,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          Get.dialog(
                            AlertDialog(
                              title: const Text("Delete comment"),
                              content: const Text(
                                  "Are you sure you want to delete this comment?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    onDelete();
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  )
                : null,
          ),
          const VerticalSpace(height: 4)
        ],
      ),
    );
  }
}
