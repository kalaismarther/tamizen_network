import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/auth_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var userDp = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userName.value = user.name;
    userDp.value = user.profileImageUrl;
    email.value = user.email;
    super.onInit();
  }

  Future<void> logout() async {
    try {
      UiHelper.showLoadingDialog();
      final result = await ApiServices.logout();

      UiHelper.closeLoadingDialog();

      AuthHelper.logoutUser(message: result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showLogoutAlert() => Get.dialog(
        AlertDialog(
          title: Text(
            'Do you want to logout?',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                logout();
              },
              child: const Text('Yes'),
            )
          ],
        ),
      );

  Future<void> deleteAccount() async {
    try {
      UiHelper.showLoadingDialog();
      await ApiServices.deleteUserAccount();
      UiHelper.closeLoadingDialog();
      AuthHelper.logoutUser(message: 'Account Deleted Successfully');
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
