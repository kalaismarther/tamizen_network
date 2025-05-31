import 'package:get/get.dart';
import 'package:product_sharing/core/services/internet_services.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/view/screens/auth/login_screen.dart';
import 'package:product_sharing/view/screens/dashboard/dashboard_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), startApp);
    super.onInit();
  }

  @override
  void onClose() {
    Get.put(InternetServices());
    super.onClose();
  }

  Future<void> startApp() async {
    final status = StorageHelper.read('logged');
    bool alreadyLogged = status == true;
    DeviceHelper.getFCM();
    if (alreadyLogged) {
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
