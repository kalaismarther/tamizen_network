import 'package:get/get.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/view/screens/splash/splash_screen.dart';

class AuthHelper {
  static void logoutUser({String? message}) async {
    await StorageHelper.deleteAll();
    UiHelper.showToast(message ?? 'Session Expired');
    Get.offAll(() => const SplashScreen());
  }
}
