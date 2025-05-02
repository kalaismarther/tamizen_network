import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/post/delete_post_request_model.dart';
import 'package:product_sharing/model/post/post_detail_request_model.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/model/post/requested_customer_list_request_model.dart';
import 'package:product_sharing/model/post/requested_customer_model.dart';

class MypostDetailController extends GetxController {
  final PostModel post;

  MypostDetailController({required this.post});

  var isLoading = false.obs;
  var images = <String>[].obs;
  var currentIndex = 0.obs;
  final PageController pageController = PageController();
  var title = ''.obs;
  var productCategoryId = ''.obs;
  var cityName = ''.obs;
  var ownerName = ''.obs;
  var ownerNumber = ''.obs;
  var description = ''.obs;
  var quantity = ''.obs;

  var activePost = true.obs;
  var error = Rxn<String>();
  var showActionIcons = false.obs;

  var requestedCustomersLoading = false.obs;
  var requestedCustomerList = <RequestedCustomerModel>[].obs;
  var requestedCustomerListError = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  @override
  void onInit() async {
    await getMyPostDetail();
    super.onInit();
  }

  Future<void> getMyPostDetail() async {
    try {
      requestedCustomerList.clear();
      showActionIcons.value = false;
      isLoading.value = true;
      update();
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
      description.value = result['description']?.toString() ?? '';
      quantity.value = result['quantity']?.toString() ?? '';
      activePost.value = result['status']?.toString().toLowerCase() == 'active';
      showActionIcons.value = true;
      update();

      isLoading.value = false;
      requestedCustomersLoading.value = true;
      scrollController.addListener(loadMore);
      await getRequestedCustomers();
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deletePost(PostModel post) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeletePostRequestModel(userId: user.id, postId: post.id);
      final result = await ApiServices.deleteMyPost(input);
      UiHelper.closeLoadingDialog();
      UiHelper.showToast(result);
      Get.back();
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> getRequestedCustomers() async {
    try {
      requestedCustomersLoading.value = true;
      final user = StorageHelper.getUserDetail();

      final input = RequestedCustomerListRequestModel(
          userId: user.id, postId: post.id, pageNo: pageNo ?? 0);

      final result = await ApiServices.getRequestedCustomerList(input);
      requestedCustomerList.addAll(result);
    } catch (e) {
      if (requestedCustomerList.isEmpty) {
        requestedCustomerListError.value =
            UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      requestedCustomersLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != requestedCustomerList.length) {
        paginationLoading.value = true;
        getRequestedCustomers();
      }
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
