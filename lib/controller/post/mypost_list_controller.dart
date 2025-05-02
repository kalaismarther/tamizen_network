import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/delete_post_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class MypostListController extends GetxController {
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getMyPosts();
    super.onInit();
  }

  var isLoading = false.obs;
  var mypostList = <PostModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getMyPosts() async {
    try {
      error.value = null;
      pageNo = mypostList.length;

      final user = StorageHelper.getUserDetail();

      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          myPost: true,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);
      mypostList.addAll(result);
    } catch (e) {
      if (mypostList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != mypostList.length) {
        paginationLoading.value = true;

        getMyPosts();
      }
    }
  }

  Future<void> deletePost(PostModel post) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeletePostRequestModel(userId: user.id, postId: post.id);
      final result = await ApiServices.deleteMyPost(input);
      bool removed = mypostList.remove(post);
      if (removed) {
        UiHelper.showToast(result);
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showDeleteAlert(PostModel post) => Get.dialog(
        AlertDialog(
          title: const Text("Delete Post"),
          content: const Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                deletePost(post);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
}
