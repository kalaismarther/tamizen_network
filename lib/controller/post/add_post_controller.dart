import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/dashboard/dashboard_controller.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/city_model.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/model/post/add_post_request_model.dart';
import 'package:product_sharing/view/screens/category/category_list_screen.dart';
import 'package:product_sharing/view/widgets/city_list.dart';

class AddPostController extends GetxController {
  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    contactName.text = user.name;
    contactEmail.text = user.email;
    contactNumber.text = user.mobile;
    super.onInit();
  }

  var productName = ''.obs;

  var productImages = <String>[].obs;
  var availableQuantity = 1.obs;
  var selectedCategory = Rxn<CategoryModel>();
  var description = ''.obs;
  TextEditingController contactName = TextEditingController();
  TextEditingController contactEmail = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  var showContactNumber = true.obs;
  var selectedCity = Rxn<CityModel>();

  void showImagePickerDialog() {
    UiHelper.unfocus();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppTheme.blue,
              ),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppTheme.blue,
              ),
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
    if (source == ImageSource.camera) {
      final XFile? image =
          await ImagePicker().pickImage(source: source, imageQuality: 50);
      if (image != null) {
        productImages.add(image.path);
      }
    } else {
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final List<XFile>? images = await ImagePicker().pickMultiImage();

      if (images != null) {
        for (final image in images) {
          productImages.add(image.path);
        }
      }
    }
  }

  void chooseCategory() async {
    UiHelper.unfocus();
    final category =
        await Get.to(() => const CategoryListScreen(chooseCategory: true));

    if (category != null && category.runtimeType == CategoryModel) {
      selectedCategory.value = category;
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
    if (productName.value.isEmpty) {
      UiHelper.showToast('Please enter product name');
      return false;
    } else if (productImages.length < 2) {
      UiHelper.showToast('Please select atleast 2 product images');
      return false;
    } else if (selectedCategory.value == null) {
      UiHelper.showToast('Please select category');
      return false;
    } else if (description.value.isEmpty) {
      UiHelper.showToast('Please enter description');
      return false;
    } else if (contactName.text.trim().isEmpty) {
      UiHelper.showToast('Please enter contact name');
      return false;
    } else if (!ValidationHelper.nameRegex.hasMatch(contactName.text.trim())) {
      UiHelper.showToast('Invalid contact name');
      return false;
    } else if (contactEmail.text.trim().isEmpty) {
      UiHelper.showToast('Please enter email address');
      return false;
    } else if (!ValidationHelper.emailRegex
        .hasMatch(contactEmail.text.trim())) {
      UiHelper.showToast('Invalid email address');
      return false;
    } else if (contactNumber.text.trim().isEmpty) {
      UiHelper.showToast('Please enter contact number');
      return false;
    } else if (!ValidationHelper.numberRegex
        .hasMatch(contactNumber.text.trim())) {
      UiHelper.showToast('Invalid contact number');
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
      UiHelper.unfocus();
      final valid = validateAll();
      if (valid) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = AddPostRequestModel(
            userId: user.id,
            productName: productName.value,
            imagesPath: productImages,
            availableQuantity: availableQuantity.value,
            categoryId: selectedCategory.value?.id ?? '',
            description: description.value,
            contactName: contactName.text.trim(),
            contactEmail: contactEmail.text.trim(),
            contactNumber: contactNumber.text.trim(),
            showContactNumber: showContactNumber.value,
            cityId: selectedCity.value?.id ?? '');

        await ApiServices.addPost(input);

        Get.find<DashboardController>().changeTab(3);
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
