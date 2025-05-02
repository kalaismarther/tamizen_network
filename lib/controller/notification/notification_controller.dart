import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/notification/notification_model.dart';
import 'package:product_sharing/model/notification/notification_request_model.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getMyNotifications();
    super.onInit();
  }

  var isLoading = false.obs;
  var notificationList = <NotificationModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getMyNotifications() async {
    try {
      error.value = null;
      pageNo = notificationList.length;

      final user = StorageHelper.getUserDetail();

      final input = NotificationRequestModel(
        userId: user.id,
        pageNo: pageNo ?? 0,
      );

      final result = await ApiServices.getNotificationList(input);
      notificationList.addAll(result);
    } catch (e) {
      if (notificationList.isEmpty) {
        error.value = UiHelper.getMsgFromException(e.toString());
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (scrollController.position.maxScrollExtent == scrollController.offset) {
      if (pageNo != null && pageNo != notificationList.length) {
        paginationLoading.value = true;
        getMyNotifications();
      }
    }
  }
}
