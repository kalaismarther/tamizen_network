import 'package:get/get.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/city_model.dart';
import 'package:product_sharing/model/auth/signup_request_model.dart';
import 'package:product_sharing/view/screens/auth/verification_screen.dart';

class SignupController extends GetxController {
  var name = ''.obs;
  var mobileNumber = ''.obs;
  var emailAddress = ''.obs;
  var password = ''.obs;
  RxBool hidePassword = true.obs;

  RxBool citiesLoading = false.obs;
  var searchCity = ''.obs;
  var cityList = <CityModel>[].obs;
  var selectedCity = Rxn<CityModel>();
  var cityListError = Rxn<String>();

  var agreedToTerms = false.obs;

  @override
  void onInit() {
    getCities();
    super.onInit();
  }

  Future<void> getCities() async {
    try {
      citiesLoading.value = true;
      cityListError.value = null;
      final result = await ApiServices.getCityList(searchCity.value);
      cityList.value = result;
    } catch (e) {
      cityListError.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      citiesLoading.value = false;
    }
  }

  bool validateAll() {
    if (name.value.isEmpty) {
      UiHelper.showToast('Please enter name');
      return false;
    } else if (!ValidationHelper.nameRegex.hasMatch(name.value)) {
      UiHelper.showToast('Invalid name');
      return false;
    } else if (mobileNumber.value.isEmpty) {
      UiHelper.showToast('Please enter mobile number');
      return false;
    } else if (!ValidationHelper.numberRegex.hasMatch(mobileNumber.value)) {
      UiHelper.showToast('Invalid mobile number');
      return false;
    } else if (emailAddress.value.isEmpty) {
      UiHelper.showToast('Please enter email address');
      return false;
    } else if (!ValidationHelper.emailRegex.hasMatch(emailAddress.value)) {
      UiHelper.showToast('Invalid email address');
      return false;
    } else if (password.value.isEmpty || password.value.length < 6) {
      UiHelper.showToast('Password must be 6 characters');
      return false;
    } else if (selectedCity.value == null) {
      UiHelper.showToast('Please select city');
      return false;
    } else if (!agreedToTerms.value) {
      UiHelper.showToast('Please accept our terms and conditions to continue');
      return false;
    } else {
      return true;
    }
  }

  Future<void> signUp() async {
    try {
      UiHelper.unfocus();
      final valid = validateAll();

      if (valid) {
        UiHelper.showLoadingDialog();
        final device = await DeviceHelper.getDeviceInfo();
        var input = SignupRequestModel(
            name: name.value,
            email: emailAddress.value,
            password: password.value,
            mobile: mobileNumber.value,
            city: selectedCity.value!,
            deviceType: device.type);

        final result = await ApiServices.userSignup(input);
        await StorageHelper.write('user', result);
        Get.off(() => const VerificationScreen(
              type: 'signup',
            ));
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
