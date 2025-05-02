import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/chat/chat_list_request_model.dart';
import 'package:product_sharing/model/chat/chat_model.dart';
import 'package:product_sharing/model/chat/delete_chat_request_model.dart';
import 'package:product_sharing/model/chat/like_chat_request_model.dart';
import 'package:product_sharing/model/chat/report_chat_request_model.dart';

class ChatListController extends GetxController {
  @override
  void onInit() {
    chatList.clear();
    final user = StorageHelper.getUserDetail();
    myProfileImage.value = user.profileImageUrl;
    isLoading.value = true;
    scrollController.addListener(loadMore);
    fetchChats();
    super.onInit();
  }

  var myProfileImage = ''.obs;

  var isLoading = false.obs;
  var chatList = <ChatModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> fetchChats() async {
    try {
      error.value = null;
      pageNo = chatList.length;

      final user = StorageHelper.getUserDetail();

      final input = ChatListRequestModel(
        userId: user.id,
        pageNo: pageNo ?? 0,
      );

      final result = await ApiServices.getChatList(input);
      chatList.addAll(result);
    } catch (e) {
      if (chatList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != chatList.length) {
        paginationLoading.value = true;
        fetchChats();
      }
    }
  }

  Future<void> toggleChatLike(ChatModel chat, bool addLike) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = LikeChatRequestModel(
          userId: user.id, chatId: chat.id, addLike: addLike);
      await ApiServices.addLikeToChat(input);
      toggleLikeIcon(chat, addLike);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void toggleLikeIcon(ChatModel chat, bool added) {
    final inChatList = chatList.firstWhereOrNull((e) => e.id == chat.id);

    if (inChatList != null) {
      final chatIndex = chatList.indexOf(inChatList);
      if (added) {
        chatList[chatIndex].isLiked = true;
        chatList[chatIndex].likesCount++;
      } else {
        chatList[chatIndex].isLiked = false;
        chatList[chatIndex].likesCount--;
      }
    }
    chatList.refresh();
  }

  Future<void> deleteChat(ChatModel chat) async {
    try {
      final inChatList = chatList.firstWhereOrNull((e) => e.id == chat.id);

      if (inChatList != null) {
        final index = chatList.indexOf(inChatList);
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input =
            DeleteChatRequestModel(userId: user.id, chatId: chatList[index].id);

        final result = await ApiServices.deleteChat(input);

        UiHelper.showToast(result);

        chatList.remove(chatList[index]);
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  final reportController = TextEditingController();

  Future<void> reportChat(ChatModel chat) async {
    try {
      if (reportController.text.trim().isEmpty) {
        return;
      }
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = ReportChatRequestModel(
          userId: user.id,
          chatId: chat.id,
          content: reportController.text.trim());

      final result = await ApiServices.reportChat(input);

      UiHelper.showToast(result);
      reportController.clear();
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
