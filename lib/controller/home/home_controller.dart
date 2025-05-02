import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/auth_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/category/category_list_request_model.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';

class HomeController extends GetxController {
  var userName = ''.obs;
  var userDp = ''.obs;
  var userCity = ''.obs;
  var notificationCount = 0.obs;

  //CATEGORIES
  var categoriesLoading = false.obs;
  var categoryList = <CategoryModel>[].obs;
  var categoryListError = Rxn<String>();

  //LATEST POSTS
  var latestPostsLoading = false.obs;
  var latestPostList = <PostModel>[].obs;
  var latestPostListError = Rxn<String>();

  //POPULAR POSTS
  var popularPostsLoading = false.obs;
  var popularPostList = <PostModel>[].obs;
  var popularPostListError = Rxn<String>();

  @override
  void onInit() async {
    await loadHomeContent();
    super.onInit();
  }

  Future<void> loadHomeContent() async {
    await Future.wait([
      getUserDetail(),
      getCategories(),
      getLatestPosts(),
      getPopularPosts()
    ]);
    await checkUserStatus();
  }

  Future<void> getUserDetail() async {
    final user = StorageHelper.getUserDetail();
    userName.value = user.name;
    userDp.value = user.profileImageUrl;
    userCity.value = user.city.name;
  }

  Future<void> checkUserStatus() async {
    try {
      final user = StorageHelper.getUserDetail();

      final result = await ApiServices.getUserInfo(user.id);

      if (result['status']?.toString() != 'ACTIVE') {
        AuthHelper.logoutUser(message: 'Your account has been inactivated');
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    }
  }

  Future<void> getCategories() async {
    try {
      categoriesLoading.value = true;
      final user = StorageHelper.getUserDetail();

      final input = CategoryListRequestModel(
          userId: user.id, pageNo: 0, search: '', apiToken: user.apiToken);

      final result = await ApiServices.getCategoryList(input);
      notificationCount.value =
          int.tryParse(result['notification_count']?.toString() ?? '0') ?? 0;
      categoryList.value = [
        for (final category in result['data'] ?? [])
          CategoryModel.fromJson(category)
      ];
    } catch (e) {
      categoryListError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      categoriesLoading.value = false;
    }
  }

  Future<void> getLatestPosts() async {
    try {
      latestPostsLoading.value = true;
      final user = StorageHelper.getUserDetail();

      final input = PostListRequestModel(
          userId: user.id,
          pageNo: 0,
          cityId: user.city.id,
          type: '1',
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);
      latestPostList.value = result;
    } catch (e) {
      latestPostListError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      latestPostsLoading.value = false;
    }
  }

  Future<void> getPopularPosts() async {
    try {
      popularPostsLoading.value = true;
      final user = StorageHelper.getUserDetail();
      final input = PostListRequestModel(
          userId: user.id,
          pageNo: 0,
          cityId: user.city.id,
          type: '2',
          apiToken: user.apiToken);
      final result = await ApiServices.getPostList(input);
      popularPostList.value = result;
    } catch (e) {
      popularPostListError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      popularPostsLoading.value = false;
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
    final inLatestPost =
        latestPostList.firstWhereOrNull((e) => e.id == post.id);

    final inPopularPost =
        popularPostList.firstWhereOrNull((e) => e.id == post.id);

    if (inLatestPost != null) {
      final latestPostIndex = latestPostList.indexOf(inLatestPost);
      if (added) {
        latestPostList[latestPostIndex].isWishlisted = true;
      } else {
        latestPostList[latestPostIndex].isWishlisted = false;
      }
    }

    if (inPopularPost != null) {
      final popularPostIndex = popularPostList.indexOf(inPopularPost);
      if (added) {
        popularPostList[popularPostIndex].isWishlisted = true;
      } else {
        popularPostList[popularPostIndex].isWishlisted = false;
      }
    }

    latestPostList.refresh();
    popularPostList.refresh();
  }
}
