import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/home/home_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/launcher_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/add_wishlist_request_model.dart';
import 'package:product_sharing/model/post/post_detail_request_model.dart';
import 'package:product_sharing/model/post/post_list_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/model/post/report_post_request_model.dart';
import 'package:product_sharing/model/post/send_request_model.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class PostDetailController extends GetxController {
  final PostModel post;

  PostDetailController({required this.post});

  var isLoading = false.obs;

  //FOR PRODUCT IMAGES
  var images = <String>[].obs;
  var currentIndex = 0.obs;
  final PageController pageController = PageController();

  var title = ''.obs;
  var productCategoryId = ''.obs;
  var cityName = ''.obs;
  var ownerName = ''.obs;
  var ownerEmail = ''.obs;
  var ownerNumber = ''.obs;
  var showOwnerNumber = false.obs;
  var description = ''.obs;
  var quantity = ''.obs;
  var error = Rxn<String>();
  var alreadyRequested = false.obs;
  var activePost = true.obs;

  final reportController = TextEditingController();

  @override
  void onInit() async {
    await getPostDetail();
    super.onInit();
  }

  Future<void> getPostDetail() async {
    try {
      isLoading.value = true;
      final user = StorageHelper.getUserDetail();
      final input = PostDetailRequestModel(userId: user.id, postId: post.id);

      final result = await ApiServices.postDetail(input);

      images.value = [
        for (final image in result['products_images'] ?? [])
          image['is_image']?.toString() ?? ''
      ];

      title.value = result['name']?.toString() ?? '';
      productCategoryId.value = result['category_id']?.toString() ?? '';
      cityName.value = result['city']?['name']?.toString() ?? '';
      ownerName.value = result['contact_name']?.toString() ?? '';
      ownerNumber.value = result['contact_number']?.toString() ?? '';
      ownerEmail.value = result['contact_email']?.toString() ?? '';
      showOwnerNumber.value = result['view_contact']?.toString() == '1';
      description.value = result['description']?.toString() ?? '';
      quantity.value = result['quantity']?.toString() ?? '';
      alreadyRequested.value = result['is_request']?.toString() == '1';
      activePost.value = result['status']?.toString().toLowerCase() == 'active';
      if (productCategoryId.value.isNotEmpty) {
        isLoading.value = false;
        similarPostLoading.value = true;
        scrollController.addListener(loadMore);
        await getSimilarPosts();
      }
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void showContactDialog() {
    if (ownerEmail.value.isEmpty && !showOwnerNumber.value) {
      UiHelper.showToast('No contact details found');
    } else {
      Get.dialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ownerEmail.value.isNotEmpty) ...[
                const Text('Email'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ownerEmail.value,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        LauncherHelper.openMailApp(ownerEmail.value);
                      },
                      icon: Image.asset(
                        AppImages.mail,
                        height: 30.sp,
                      ),
                    )
                  ],
                ),
              ],
              if (showOwnerNumber.value) ...[
                const VerticalSpace(height: 20),
                const Text('Mobile number'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ownerNumber.value,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        LauncherHelper.openDialerApp(ownerNumber.value);
                      },
                      icon: Image.asset(
                        AppImages.phone,
                        height: 30.sp,
                      ),
                    )
                  ],
                ),
              ]
            ],
          ),
        ),
      );
    }
  }

  Future<void> sendRequestToOwner() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = SendRequestModel(userId: user.id, postId: post.id);
      final result = await ApiServices.sendRequest(input);
      alreadyRequested.value = true;
      UiHelper.showToast(result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  var similarPostLoading = false.obs;
  var similarPostList = <PostModel>[].obs;
  var similarPostError = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;
  final scrollController = ScrollController();

  Future<void> getSimilarPosts() async {
    try {
      error.value = null;
      pageNo = similarPostList.length;
      final user = StorageHelper.getUserDetail();
      final input = PostListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          cityId: user.city.id,
          categoryId: productCategoryId.value,
          apiToken: user.apiToken);

      final result = await ApiServices.getPostList(input);

      similarPostList.addAll(result);
    } catch (e) {
      if (similarPostList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      similarPostLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null) {
        paginationLoading.value = true;
        getSimilarPosts();
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
      final inSimilarPost = similarPostList.firstWhere((e) => e.id == post.id);

      final similarPostIndex = similarPostList.indexOf(inSimilarPost);

      if (added) {
        similarPostList[similarPostIndex].isWishlisted = true;
      } else {
        similarPostList[similarPostIndex].isWishlisted = false;
      }
      similarPostList.refresh();
      final homeController = Get.find<HomeController>();
      homeController.toggleWishlistIcon(post, added);
    } catch (e) {
      //
    }
  }

  Future<void> reportPost() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();

      final input = ReportPostRequestModel(
          userId: user.id,
          postId: post.id,
          reason: reportController.text.trim());

      final result = await ApiServices.reportPost(input);

      UiHelper.showToast(result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
