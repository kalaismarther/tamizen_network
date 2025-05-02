import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/chat/chat_list_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/chat/add_chat_request_model.dart';

class AddChatController extends GetxController {
  final contentController = TextEditingController();

  Future<void> addChat() async {
    try {
      if (contentController.text.trim().isEmpty) {
        return;
      }
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddChatRequestModel(
          userId: user.id, content: contentController.text.trim());

      final result = await ApiServices.addChat(input);

      UiHelper.showToast(result);
      UiHelper.closeLoadingDialog();
      Get.back();
      Get.find<ChatListController>().onInit();
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
