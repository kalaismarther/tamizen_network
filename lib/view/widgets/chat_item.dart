import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/model/chat/chat_model.dart';
import 'package:product_sharing/view/screens/chat/comment_list_screen.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/report_chat_dialog.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class ChatItem extends StatelessWidget {
  const ChatItem(
      {super.key,
      required this.chat,
      required this.onLike,
      required this.onRemoveLike,
      required this.onDelete,
      required this.onReport,
      this.onList = true});

  final ChatModel chat;
  final Function() onLike;
  final Function() onRemoveLike;
  final Function() onDelete;
  final Function() onReport;
  final bool onList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpace(height: 4),
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: OnlineImage(
              link: chat.creatorImage,
              height: 44.sp,
              width: 44.sp,
              radius: 0,
              shape: BoxShape.circle,
              errorWidget: Image.asset(
                AppImages.avatar,
                height: 44.sp,
                width: 44.sp,
              ),
            ),
            title: Text(
              chat.creatorName,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              chat.createdTime,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
            trailing: PopupMenuButton(
              color: Colors.white,
              icon: Image.asset(
                AppImages.chatMenu,
                height: 20.sp,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                if (!chat.byMe)
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            ReportChatDialog(onSubmit: onReport),
                      );
                    },
                    child: const Text('Report'),
                  ),
                if (chat.byMe)
                  PopupMenuItem(
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Delete Chat"),
                          content: const Text(
                              "Are you sure you want to delete this chat?"),
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
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Delete'),
                  ),
              ],
            ),
          ),
          Text(
            chat.content,
            style: TextStyle(fontSize: 14.sp),
          ),
          const VerticalSpace(height: 12),
          Row(
            children: [
              if (chat.isLiked)
                InkWell(
                  onTap: onRemoveLike,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Image.asset(AppImages.liked, height: 20.sp),
                  ),
                )
              else
                InkWell(
                  onTap: onLike,
                  child: Padding(
                    padding: EdgeInsets.all(8.sp),
                    child: Image.asset(AppImages.like, height: 20.sp),
                  ),
                ),
              Text(
                chat.likesCount.toString(),
              ),
              const HorizontalSpace(width: 12),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.7,
                      child: CommentListScreen(chat: chat),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.sp),
                      child: Image.asset(AppImages.comment, height: 20.sp),
                    ),
                  ],
                ),
              ),
              Text(
                chat.commentsCount.toString(),
              ),
            ],
          ),
          const VerticalSpace(height: 16)
        ],
      ),
    );
  }
}
