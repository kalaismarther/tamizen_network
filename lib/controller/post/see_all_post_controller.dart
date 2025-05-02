import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/home/home_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class SeeAllPostController extends GetxController {
  final String type;
  SeeAllPostController({required this.type});
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getAllPosts();
    super.onInit();
  }

  var isLoading = false.obs;
  var allPostList = <PostModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getAllPosts() async {
    try {
      error.value = null;
      pageNo = allPostList.length;

      final user = StorageHelper.getUserDetail();

      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          type: type,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);
      allPostList.addAll(result);
    } catch (e) {
      if (allPostList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null) {
        paginationLoading.value = true;
        getAllPosts();
      }
    }
  }

  Future<void> toggleWishlist(PostModel post) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddWishlistRequestModel(userId: user.id, postId: post.id);
      final result = await ApiServices.addToWishlist(input);

      toggleWishlistIcon(post, result['add_remove']?.toString() == '1');

      UiHelper.showToast(result['message'] ?? '');
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void toggleWishlistIcon(PostModel post, bool added) {
    try {
      final inAllPost = allPostList.firstWhereOrNull((e) => e.id == post.id);

      if (inAllPost != null) {
        final postIndex = allPostList.indexOf(inAllPost);

        if (added) {
          allPostList[postIndex].isWishlisted = true;
        } else {
          allPostList[postIndex].isWishlisted = false;
        }
      }
      allPostList.refresh();
      final homeController = Get.find<HomeController>();
      homeController.toggleWishlistIcon(post, added);
    } catch (e) {
      //
    }
  }
}
