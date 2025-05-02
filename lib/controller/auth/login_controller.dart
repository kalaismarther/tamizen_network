import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/core/utils/response_status.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/login_request_model.dart';
import 'package:product_sharing/view/screens/auth/verification_screen.dart';
import 'package:product_sharing/view/screens/dashboard/dashboard_screen.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  RxBool hidePassword = true.obs;

  bool validateAll() {
    if (email.value.isEmpty) {
      UiHelper.showToast('Please enter email address');
      return false;
    } else if (!ValidationHelper.emailRegex.hasMatch(email.value)) {
      UiHelper.showToast('Invalid email address');
      return false;
    } else if (password.value.isEmpty || password.value.length < 6) {
      UiHelper.showToast('Password must be 6 characters');
      return false;
    } else {
      return true;
    }
  }

  Future<void> login() async {
    try {
      bool valid = validateAll();

      if (valid) {
        UiHelper.unfocus();
        UiHelper.showLoadingDialog();
        final device = await DeviceHelper.getDeviceInfo();
        var input = LoginRequestModel(
            email: email.value.trim(),
            password: password.value.trim(),
            deviceType: device.type,
            deviceId: device.id,
            fcmId: 'dksk');

        final result = await ApiServices.userLogin(input);

        if (result == ResponseStatus.done) {
          UiHelper.closeLoadingDialog();
          Get.to(() => const DashboardScreen());
        } else if (result == ResponseStatus.otpNotVerified) {
          UiHelper.closeLoadingDialog();

          Get.to(() => const VerificationScreen(type: 'login'));
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
