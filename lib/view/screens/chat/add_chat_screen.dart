import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:product_sharing/controller/chat/add_chat_controller.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class AddChatScreen extends StatelessWidget {
  const AddChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddChatController>(
      init: AddChatController(),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'Add Post'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: controller.contentController,
                decoration:
                    const InputDecoration(hintText: 'Write something...'),
                maxLines: 4,
              ),
              const VerticalSpace(height: 20),
              ElevatedButton(
                onPressed: controller.addChat,
                child: const Text('Post'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
