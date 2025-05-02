import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/chat/comment_list_controller.dart';
import 'package:product_sharing/model/chat/chat_model.dart';
import 'package:product_sharing/view/widgets/comment_item.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class CommentListScreen extends StatelessWidget {
  const CommentListScreen({super.key, required this.chat});

  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentListController>(
      init: CommentListController(chat: chat),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          body: Column(
            children: [
              const VerticalSpace(height: 16),
              Center(
                child: Text(
                  'Comments',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return ListView.separated(
                        controller: controller.scrollController,
                        padding: EdgeInsets.all(16.sp),
                        itemCount: 5,
                        separatorBuilder: (context, index) =>
                            const VerticalSpace(height: 20),
                        itemBuilder: (context, index) => LoadingShimmer(
                            height: 90.sp, width: double.infinity, radius: 12),
                      );
                    }

                    if (controller.error.value != null) {
                      return Center(
                        child: Text(controller.error.value ?? ''),
                      );
                    }

                    return ListView.separated(
                      controller: controller.scrollController,
                      itemCount: controller.commentList.length +
                          (controller.paginationLoading.value ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const VerticalSpace(height: 4),
                      padding: EdgeInsets.all(16.sp),
                      itemBuilder: (context, index) =>
                          index < controller.commentList.length
                              ? CommentItem(
                                  comment: controller.commentList[index],
                                  onDelete: () => controller.deleteComment(
                                      controller.commentList[index]),
                                )
                              : const CupertinoActivityIndicator(),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.commentController,
                        decoration:
                            const InputDecoration(hintText: 'Add comment'),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.addComment,
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
