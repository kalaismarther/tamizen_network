import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class WishlistController extends GetxController {
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getWishlistItems();
    super.onInit();
  }

  var isLoading = false.obs;
  var wishlistItems = <PostModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getWishlistItems() async {
    try {
      error.value = null;
      pageNo = wishlistItems.length;

      final user = StorageHelper.getUserDetail();

      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          wishlist: true,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);
      wishlistItems.addAll(result);
    } catch (e) {
      if (wishlistItems.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != wishlistItems.length) {
        paginationLoading.value = true;

        getWishlistItems();
      }
    }
  }

  Future<void> removePostFromWishlist(PostModel post) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddWishlistRequestModel(userId: user.id, postId: post.id);
      print(input.toJson());
      final result = await ApiServices.addToWishlist(input);

      wishlistItems.remove(post);
      UiHelper.showToast(result['message'] ?? '');
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showDeleteAlert(PostModel post) => Get.dialog(
        AlertDialog(
          title: const Text("Remove Post"),
          content: const Text(
              "Are you sure you want to remove the post from wishlist?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                removePostFromWishlist(post);
              },
              child: const Text("Remove", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
}
