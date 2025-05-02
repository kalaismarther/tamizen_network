import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/model/auth/city_model.dart';

class CityListController extends GetxController {
  @override
  void onInit() {
    searchCity.value = '';
    getCities();
    super.onInit();
  }

  var isLoading = false.obs;
  var searchCity = ''.obs;
  var cityList = <CityModel>[].obs;

  var error = Rxn<String>();

  Future<void> getCities() async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await ApiServices.getCityList(searchCity.value);
      cityList.value = result;
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
