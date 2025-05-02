import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/home/home_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class SearchResultController extends GetxController {
  final String keyword;

  SearchResultController({required this.keyword});

  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    searchPosts();
    super.onInit();
  }

  var isLoading = false.obs;
  var postList = <PostModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> searchPosts() async {
    try {
      error.value = null;
      pageNo = postList.length;
      final user = StorageHelper.getUserDetail();
      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          search: keyword,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);

      postList.addAll(result);
    } catch (e) {
      if (postList.isEmpty) {
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
        searchPosts();
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
      final inSearchResultPost =
          postList.firstWhereOrNull((e) => e.id == post.id);

      if (inSearchResultPost != null) {
        final postIndex = postList.indexOf(inSearchResultPost);

        if (added) {
          postList[postIndex].isWishlisted = true;
        } else {
          postList[postIndex].isWishlisted = false;
        }
      }

      postList.refresh();
      final homeController = Get.find<HomeController>();
      homeController.toggleWishlistIcon(post, added);
    } catch (e) {
      //
    }
  }
}
