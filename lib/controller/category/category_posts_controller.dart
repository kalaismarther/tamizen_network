import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/home/home_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class CategoryPostsController extends GetxController {
  final CategoryModel category;
  CategoryPostsController({required this.category});

  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getCategoryPosts();
    super.onInit();
  }

  var isLoading = false.obs;
  var categoryPostList = <PostModel>[].obs;
  var error = Rxn<String>();
  var searchKeyword = ''.obs;
  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getCategoryPosts() async {
    try {
      error.value = null;
      pageNo = categoryPostList.length;
      final user = StorageHelper.getUserDetail();
      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          categoryId: category.id,
          search: searchKeyword.value,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);

      categoryPostList.addAll(result);
    } catch (e) {
      if (categoryPostList.isEmpty) {
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
        getCategoryPosts();
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
      final inCategoryPost =
          categoryPostList.firstWhereOrNull((e) => e.id == post.id);

      if (inCategoryPost != null) {
        final categoryPostIndex = categoryPostList.indexOf(inCategoryPost);

        if (added) {
          categoryPostList[categoryPostIndex].isWishlisted = true;
        } else {
          categoryPostList[categoryPostIndex].isWishlisted = false;
        }
      }
      categoryPostList.refresh();
      final homeController = Get.find<HomeController>();
      homeController.toggleWishlistIcon(post, added);
    } catch (e) {
      //
    }
  }
}
