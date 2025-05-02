import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';
import 'package:product_sharing/controller/chat/chat_list_controller.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class ReportChatDialog extends StatelessWidget {
  const ReportChatDialog({super.key, required this.onSubmit});

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      builder: (controller) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 15,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Report',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              const VerticalSpace(height: 12),
              TextFormField(
                autofocus: true,
                controller: controller.reportController,
                decoration:
                    const InputDecoration(hintText: 'Write something...'),
                maxLines: 4,
              ),
              const VerticalSpace(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (controller.reportController.text.isNotEmpty) {
                    Get.back();
                    onSubmit();
                  }
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
