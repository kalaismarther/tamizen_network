import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:product_sharing/controller/chat/chat_list_controller.dart';
import 'package:product_sharing/view/screens/chat/add_chat_screen.dart';
import 'package:product_sharing/view/widgets/chat_item.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      init: ChatListController(),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'Chat'),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Row(
                children: [
                  OnlineImage(
                    link: controller.myProfileImage.value,
                    height: 48.sp,
                    width: 48.sp,
                    radius: 0,
                    shape: BoxShape.circle,
                  ),
                  const HorizontalSpace(width: 12),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => Get.to(() => const AddChatScreen()),
                      decoration:
                          const InputDecoration(hintText: 'Write something...'),
                    ),
                  )
                ],
              ),
            ),
            const VerticalSpace(height: 12),
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
                    itemCount: controller.chatList.length +
                        (controller.paginationLoading.value ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const VerticalSpace(height: 24),
                    padding: EdgeInsets.all(16.sp),
                    itemBuilder: (context, index) =>
                        index < controller.chatList.length
                            ? ChatItem(
                                chat: controller.chatList[index],
                                onLike: () => controller.toggleChatLike(
                                    controller.chatList[index], true),
                                onRemoveLike: () => controller.toggleChatLike(
                                    controller.chatList[index], false),
                                onDelete: () => controller
                                    .deleteChat(controller.chatList[index]),
                                onReport: () => controller
                                    .reportChat(controller.chatList[index]),
                              )
                            : const CupertinoActivityIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () => Get.to(() => const AddChatScreen()),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
