import 'dart:async';

import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/auth/verification_request_model.dart';
import 'package:product_sharing/view/screens/auth/change_password_screen.dart';
import 'package:product_sharing/view/screens/dashboard/dashboard_screen.dart';

class VerificationController extends GetxController {
  final String type;
  late Timer timer;
  var remainingSeconds = 30.obs;

  var otp = ''.obs;

  VerificationController({required this.type});

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() async {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void resetTimer() {
    remainingSeconds.value = 30;
    startTimer();
  }

  void cancelTimer() async {
    timer.cancel();
  }

  Future<void> verifyOtp() async {
    try {
      UiHelper.unfocus();
      UiHelper.showLoadingDialog();

      final user = StorageHelper.getUserDetail();
      final device = await DeviceHelper.getDeviceInfo();

      final input = VerificationRequestModel(
          userId: user.id, otp: otp.value, deviceId: device.id);

      final result = await ApiServices.userVerification(input);

      if (type == 'login' || type == 'signup') {
        await StorageHelper.write('user', result);
        await StorageHelper.write('logged', true);
        UiHelper.closeLoadingDialog();
        Get.offAll(() => const DashboardScreen());
      } else if (type == 'forgot_password') {
        await StorageHelper.write('user', result);
        UiHelper.closeLoadingDialog();
        Get.off(() => const ChangePasswordScreen());
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
