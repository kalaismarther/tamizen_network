import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/category/category_list_request_model.dart';
import 'package:product_sharing/model/category/category_model.dart';

class CategoryListController extends GetxController {
  final bool chooseCategory;
  CategoryListController({required this.chooseCategory});
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getCategories();
    super.onInit();
  }

  var isLoading = false.obs;

  var popularCategoryList = <CategoryModel>[].obs;
  var otherCategoryList = <CategoryModel>[].obs;
  var categoryList = <CategoryModel>[].obs;
  var categoryListError = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getCategories() async {
    try {
      categoryListError.value = null;
      pageNo = categoryList.length;
      final user = StorageHelper.getUserDetail();

      final input = CategoryListRequestModel(
          userId: user.id,
          pageNo: pageNo ?? 0,
          search: '',
          apiToken: user.apiToken);

      final result = await ApiServices.getCategoryList(input);
      var data = [
        for (final category in result['data'] ?? [])
          CategoryModel.fromJson(category)
      ];
      if (pageNo == 0) {
        popularCategoryList.addAll(data.take(5));
        otherCategoryList.addAll(data.skip(5));
      } else {
        otherCategoryList.addAll(data);
      }
      categoryList.addAll(data);
    } catch (e) {
      if (categoryList.isEmpty) {
        categoryListError.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != categoryList.length) {
        paginationLoading.value = true;
        getCategories();
      }
    }
  }
}
