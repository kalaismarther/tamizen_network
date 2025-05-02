import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/city_model.dart';
import 'package:product_sharing/model/profile/edit_profile_request_model.dart';
import 'package:product_sharing/view/widgets/city_list.dart';

class EditProfileController extends GetxController {
  var userDp = ''.obs;
  var userName = ''.obs;
  var selectedImagePath = ''.obs;
  TextEditingController name = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  var selectedCity = Rxn<CityModel>();

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userDp.value = user.profileImageUrl;
    userName.value = user.name;
    name.text = user.name;
    mobileNumber.text = user.mobile;
    email.text = user.email;
    selectedCity.value = user.city;
    super.onInit();
  }

  void showImagePickerDialog() {
    UiHelper.unfocus();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.blue),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppTheme.blue),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 50,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      //
    }
  }

  void chooseCity() async {
    UiHelper.unfocus();
    final city = await Get.bottomSheet(const CityList());
    if (city != null && city.runtimeType == CityModel) {
      selectedCity.value = city;
    }
  }

  bool validateAll() {
    if (name.text.trim().isEmpty) {
      UiHelper.showToast('Please enter name');
      return false;
    } else if (!ValidationHelper.nameRegex.hasMatch(name.text.trim())) {
      UiHelper.showToast('Invalid name');
      return false;
    } else if (mobileNumber.text.trim().isEmpty) {
      UiHelper.showToast('Please enter mobile number');
      return false;
    } else if (!ValidationHelper.numberRegex.hasMatch(
      mobileNumber.text.trim(),
    )) {
      UiHelper.showToast('Invalid mobile number');
      return false;
    } else if (email.text.trim().isEmpty) {
      UiHelper.showToast('Please enter email address');
      return false;
    } else if (!ValidationHelper.emailRegex.hasMatch(email.text.trim())) {
      UiHelper.showToast('Invalid email address');
      return false;
    } else if (selectedCity.value == null) {
      UiHelper.showToast('Please select city');
      return false;
    } else {
      return true;
    }
  }

  Future<void> submit() async {
    try {
      final valid = validateAll();

      if (valid) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = EditProfileRequestModel(
          userId: user.id,
          name: name.text.trim(),
          mobile: mobileNumber.text.trim(),
          cityId: selectedCity.value?.id ?? '0',
          profileImagePath: selectedImagePath.value,
        );

        final result = await ApiServices.editProfile(input);

        StorageHelper.write('user', result);

        UiHelper.closeLoadingDialog();
        Get.back();
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
