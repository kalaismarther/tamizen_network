import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/core/services/api_services.dart';
import 'package:product_sharing/core/utils/storage_helper.dart';
import 'package:product_sharing/core/utils/ui_helper.dart';
import 'package:product_sharing/core/utils/validation_helper.dart';
import 'package:product_sharing/model/auth/city_model.dart';
import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/model/post/delete_post_image_request_model.dart';
import 'package:product_sharing/model/post/edit_post_request_model.dart';
import 'package:product_sharing/model/post/post_detail_request_model.dart';
import 'package:product_sharing/model/post/post_image_model.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/screens/category/category_list_screen.dart';
import 'package:product_sharing/view/widgets/city_list.dart';

class EditPostController extends GetxController {
  final PostModel post;

  EditPostController({required this.post});
  var isLoading = false.obs;

  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController contactName = TextEditingController();
  TextEditingController contactEmail = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  var showContactNumber = true.obs;

  var productImages = <PostImageModel>[].obs;
  var newlySelectedImages = <String>[].obs;
  var availableQuantity = 1.obs;
  var selectedCategory = Rxn<CategoryModel>();

  var selectedCity = Rxn<CityModel>();
  var selectedStatus = 'ACTIVE'.obs;
  List<String> statusList = ['ACTIVE', 'INACTIVE'];
  var error = Rxn<String>();

  @override
  void onInit() async {
    await getMyPostDetail();
    super.onInit();
  }

  Future<void> getMyPostDetail() async {
    try {
      isLoading.value = true;
      update();
      final user = StorageHelper.getUserDetail();
      final input = PostDetailRequestModel(userId: user.id, postId: post.id);

      final result = await ApiServices.postDetail(input);

      productImages.value = [
        for (final image in result['products_images'] ?? [])
          PostImageModel.fromJson(image)
      ];

      productName.text = result['name'] ?? '';

      selectedCategory.value = CategoryModel.fromJson(result['category'] ?? {});
      availableQuantity.value =
          int.tryParse(result['quantity']?.toString() ?? '1') ?? 1;
      selectedCity.value = CityModel.fromJson(result['city'] ?? {});
      contactName.text = result['contact_name'] ?? '';
      contactEmail.text = result['contact_email'] ?? '';
      contactNumber.text = result['contact_number'] ?? '';
      showContactNumber.value = result['view_contact']?.toString() == '1';
      description.text = result['description'] ?? '';
      selectedStatus.value =
          result['status']?.toString().trim().toLowerCase() == 'active'
              ? 'ACTIVE'
              : 'INACTIVE';
      update();
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e.toString());
    } finally {
      isLoading.value = false;
    }
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
        newlySelectedImages.add(image.path);
      }
    } else {
      final List<XFile>? images = await ImagePicker().pickMultiImage();

      if (images != null) {
        for (final image in images) {
          newlySelectedImages.add(image.path);
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

  void showDeleteImageAlert(PostImageModel image) => Get.dialog(
        AlertDialog(
          title: const Text("Delete Post Image"),
          content: const Text("Are you sure you want to delete this image?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (productImages.length > 2) {
                  deletePostImage(image);
                } else {
                  UiHelper.showToast(
                      'You need to keep atleast 2 images of the product');
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

  Future<void> deletePostImage(PostImageModel image) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeletePostImageRequestModel(
          userId: user.id, postId: post.id, imageId: image.id);
      final result = await ApiServices.deletePostImage(input);
      productImages.remove(image);
      UiHelper.closeLoadingDialog();
      UiHelper.showToast(result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  bool validateAll() {
    if (productName.text.trim().isEmpty) {
      UiHelper.showToast('Please enter product name');
      return false;
    } else if (productImages.isEmpty && newlySelectedImages.isEmpty) {
      UiHelper.showToast('Please select product images');
      return false;
    } else if (selectedCategory.value == null) {
      UiHelper.showToast('Please select category');
      return false;
    } else if (description.text.trim().isEmpty) {
      UiHelper.showToast('Please enter description');
      return false;
    } else if (contactName.text.trim().isEmpty) {
      UiHelper.showToast('Please enter contact name');
      return false;
    } else if (!ValidationHelper.nameRegex.hasMatch(contactName.text.trim())) {
      UiHelper.showToast('Invalid contact name');
      return false;
    } else if (!ValidationHelper.numberRegex
        .hasMatch(contactNumber.text.trim())) {
      UiHelper.showToast('Invalid contact number');
      return false;
    } else if (contactEmail.text.trim().isEmpty) {
      UiHelper.showToast('Please enter email address');
      return false;
    } else if (!ValidationHelper.emailRegex
        .hasMatch(contactEmail.text.trim().trim())) {
      UiHelper.showToast('Invalid email address');
      return false;
    } else if (selectedCity.value == null) {
      UiHelper.showToast('Please select city');
      return false;
    } else if (selectedStatus.value.isEmpty) {
      UiHelper.showToast('Please select status');
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
        final input = EditPostRequestModel(
            userId: user.id,
            postId: post.id,
            productName: productName.text.trim(),
            imagesPath: newlySelectedImages,
            availableQuantity: availableQuantity.value,
            categoryId: selectedCategory.value?.id ?? '',
            description: description.text.trim(),
            contactName: contactName.text.trim(),
            contactEmail: contactEmail.text.trim(),
            contactNumber: contactNumber.text.trim(),
            showContactNumber: showContactNumber.value,
            cityId: selectedCity.value?.id ?? '',
            status: selectedStatus.value);

        await ApiServices.editPost(input);
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
