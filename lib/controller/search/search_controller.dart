import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/model/search/search_history_model.dart';

class SearchController extends GetxController {
  @override
  void onInit() {
    getSearchHistory();
    super.onInit();
  }

  var isLoading = false.obs;
  var searchHistoryList = <SearchHistoryModel>[].obs;
  var popularCategoryList = <CategoryModel>[].obs;

  final textController = TextEditingController();

  Future<void> getSearchHistory() async {
    try {
      isLoading.value = true;
      final result = await ApiServices.searchHistory();

      searchHistoryList.value = [
        for (final history in result['search_history'] ?? [])
          SearchHistoryModel.fromJson(history)
      ];
      popularCategoryList.value = [
        for (final category in result['top_categories'] ?? [])
          CategoryModel.fromJson(category)
      ];
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      UiHelper.showLoadingDialog();
      final result = await ApiServices.clearHistory();

      searchHistoryList.value = [
        for (final history in result['search_history'] ?? [])
          SearchHistoryModel.fromJson(history)
      ];
      popularCategoryList.value = [
        for (final category in result['top_categories'] ?? [])
          CategoryModel.fromJson(category)
      ];
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
