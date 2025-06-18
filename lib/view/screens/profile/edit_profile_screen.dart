import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/controller/profile/edit_profile_controller.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Edit Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 200.sp,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20.sp),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => InkWell(
                          onTap: controller.showImagePickerDialog,
                          child: controller.selectedImagePath.value.isEmpty
                              ? OnlineImage(
                                  link: controller.userDp.value,
                                  height: 100.sp,
                                  width: 100.sp,
                                  radius: 0,
                                  shape: BoxShape.circle,
                                )
                              : Container(
                                  height: 100.sp,
                                  width: 100.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(
                                          File(controller
                                              .selectedImagePath.value),
                                        ),
                                        onError: (exception, stackTrace) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                        ),
                      ),
                      const VerticalSpace(height: 16),
                      Text(
                        controller.userName.value,
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const VerticalSpace(height: 6),
                      TextField(
                        controller: controller.name,
                        decoration:
                            const InputDecoration(hintText: 'Enter your name'),
                      ),
                      const VerticalSpace(height: 24),
                      Text(
                        'Email',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const VerticalSpace(height: 6),
                      TextField(
                        readOnly: true,
                        controller: controller.email,
                        decoration:
                            const InputDecoration(hintText: 'Enter your email'),
                      ),
                      const VerticalSpace(height: 24),
                      if (controller.mobileNumber.text.isNotEmpty) ...[
                        Text(
                          'Mobile Number',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 6),
                        TextField(
                          controller: controller.mobileNumber,
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                              counterText: '',
                              hintText: 'Enter your mobile number'),
                        ),
                        const VerticalSpace(height: 24),
                      ],
                      Text(
                        'City',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const VerticalSpace(height: 6),
                      Obx(
                        () => TextField(
                          readOnly: true,
                          onTap: controller.chooseCity,
                          controller: TextEditingController(
                              text: controller.selectedCity.value?.name ?? ''),
                          decoration: const InputDecoration(
                            hintText: 'Select Location',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(16.sp),
            child: ElevatedButton(
              onPressed: controller.submit,
              child: const Text('Update Profile'),
            ),
          ),
        ),
      ),
    );
  }
}
