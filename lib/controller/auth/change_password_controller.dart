import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/auth/change_password_request_model.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var password = ''.obs;
  var confirmPassword = ''.obs;

  RxBool hidePassword = true.obs;
  RxBool hideConfirmPassword = true.obs;

  void changePassword() async {
    try {
      UiHelper.unfocus();
      if (password.value.isEmpty || password.value.length < 6) {
        UiHelper.showToast('Password must be 6 characters');
      } else if (confirmPassword.value != password.value) {
        UiHelper.showToast('Confirm password not matching with password');
      } else {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = ChangePasswordRequestModel(
          userId: user.id,
          password: password.value.trim(),
        );

        await ApiServices.changePassword(input);
        UiHelper.closeLoadingDialog();
        UiHelper.showToast('Password changed successfully');
        Get.back();
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
