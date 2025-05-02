import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';

class PolicyController extends GetxController {
  final String type;
  PolicyController({required this.type});

  @override
  void onInit() {
    getPolicyContent();
    super.onInit();
  }

  var isLoading = false.obs;
  var content = ''.obs;
  var error = Rxn<String>();

  Future<void> getPolicyContent() async {
    try {
      isLoading.value = true;
      final result = await ApiServices.getPolicy(type);
      content.value = result;
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
