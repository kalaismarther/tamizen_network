import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/chat/add_comment_request_model.dart';
import 'package:product_sharing/model/chat/chat_model.dart';
import 'package:product_sharing/model/chat/comment_list_request_model.dart';
import 'package:product_sharing/model/chat/comment_model.dart';
import 'package:product_sharing/model/chat/delete_comment_request_model.dart';

class CommentListController extends GetxController {
  final ChatModel chat;

  CommentListController({required this.chat});

  @override
  void onInit() {
    commentList.clear();
    isLoading.value = true;
    scrollController.addListener(loadMore);
    fetchComments();
    super.onInit();
  }

  var isLoading = false.obs;
  var commentList = <CommentModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;
  final commentController = TextEditingController();
  final scrollController = ScrollController();

  Future<void> fetchComments() async {
    try {
      error.value = null;
      pageNo = commentList.length;

      final user = StorageHelper.getUserDetail();

      final input = CommentListRequestModel(
        userId: user.id,
        chatId: chat.id,
        pageNo: pageNo ?? 0,
      );

      final result = await ApiServices.getComments(input);
      commentList.addAll(result);
    } catch (e) {
      if (commentList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != commentList.length) {
        paginationLoading.value = true;
        fetchComments();
      }
    }
  }

  Future<void> addComment() async {
    try {
      if (commentController.text.trim().isEmpty) {
        return;
      }
      UiHelper.unfocus();
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddCommentRequestModel(
          userId: user.id,
          chatId: chat.id,
          content: commentController.text.trim());

      final result = await ApiServices.addComment(input);

      UiHelper.showToast(result);
      UiHelper.closeLoadingDialog();
      commentController.clear();
      commentList.clear();
      fetchComments();
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> deleteComment(CommentModel comment) async {
    try {
      final inCommentList =
          commentList.firstWhereOrNull((e) => e.id == comment.id);

      if (inCommentList != null) {
        final index = commentList.indexOf(inCommentList);
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = DeleteCommentRequestModel(
            userId: user.id, chatId: chat.id, commentId: comment.id);

        final result = await ApiServices.deleteComment(input);

        UiHelper.showToast(result);

        commentList.remove(commentList[index]);
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
