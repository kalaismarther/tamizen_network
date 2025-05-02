import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/controller/post/edit_post_controller.dart';
import 'package:product_sharing/model/post/post_model.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/primary_appbar.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class EditPostScreen extends StatelessWidget {
  const EditPostScreen({super.key, required this.post});

  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditPostController>(
      init: EditPostController(post: post),
      builder: (controller) => Obx(
        () => SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: const PrimaryAppbar(title: 'Edit Post'),
            body: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          controller: controller.productName,
                          decoration: const InputDecoration(
                            hintText: 'Enter Product Name',
                          ),
                        ),
                        const VerticalSpace(height: 24),

                        //
                        Text(
                          'Upload New Images',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 10),
                        if (controller.newlySelectedImages.isEmpty)
                          GestureDetector(
                            onTap: controller.showImagePickerDialog,
                            child: Image.asset(
                              AppImages.upload,
                              height: 72.sp,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 16.sp,
                            runSpacing: 16.sp,
                            children: [
                              for (final image
                                  in controller.newlySelectedImages)
                                Stack(
                                  children: [
                                    Image.file(
                                      File(image),
                                      height: 80.sp,
                                      width: 80.sp,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () => controller.productImages
                                            .remove(image),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          margin: EdgeInsets.all(4.sp),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.remove_circle,
                                            color: Colors.red,
                                            size: 20.sp,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              GestureDetector(
                                onTap: controller.showImagePickerDialog,
                                child: Container(
                                  height: 80.sp,
                                  width: 80.sp,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: AppTheme.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        if (controller.productImages.isNotEmpty) ...[
                          const VerticalSpace(height: 24),
                          Text(
                            'Uploaded Images',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          const VerticalSpace(height: 16),
                          Wrap(
                            spacing: 16.sp,
                            runSpacing: 16.sp,
                            children: [
                              for (final image in controller.productImages)
                                Stack(
                                  children: [
                                    OnlineImage(
                                        link: image.url,
                                        height: 80.sp,
                                        width: 80.sp,
                                        radius: 0),
                                    // Image.file(
                                    //   File(image),
                                    //   height: 80.sp,
                                    //   width: 80.sp,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () => controller
                                            .showDeleteImageAlert(image),
                                        child: Container(
                                          clipBehavior: Clip.hardEdge,
                                          margin: EdgeInsets.all(4.sp),
                                          padding: EdgeInsets.all(4.sp),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Image.asset(
                                            AppImages.deleteIcon,
                                            height: 20.sp,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                            ],
                          ),
                        ],
                        const VerticalSpace(height: 24),
                        Text(
                          'Available Quantity',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (controller.availableQuantity.value < 2) {
                                  return;
                                } else {
                                  controller.availableQuantity.value--;
                                }
                              },
                              icon: CircleAvatar(
                                radius: 12.sp,
                                backgroundColor: AppTheme.blue,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              ),
                            ),
                            Text(
                              controller.availableQuantity.toString(),
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.w500),
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.availableQuantity.value++,
                              icon: CircleAvatar(
                                radius: 12.sp,
                                backgroundColor: AppTheme.blue,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 14.sp,
                                ),
                              ),
                            )
                          ],
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Category',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: controller.selectedCategory.value?.name ??
                                  ''),
                          onTap: controller.chooseCategory,
                          decoration: const InputDecoration(
                            hintText: 'Choose Category',
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          maxLines: 3,
                          controller: controller.description,
                          decoration: const InputDecoration(
                            hintText: 'Enter Description',
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Contact Name',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          controller: controller.contactName,
                          decoration: const InputDecoration(
                            hintText: 'Enter Contact Name',
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Contact Email',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          controller: controller.contactEmail,
                          decoration: const InputDecoration(
                            hintText: 'Enter Contact Email',
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Contact Number',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          controller: controller.contactNumber,
                          maxLength: 12,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            counterText: '',
                            hintText: 'Enter Contact number',
                          ),
                        ),
                        const VerticalSpace(height: 8),
                        SwitchListTile(
                          contentPadding: const EdgeInsets.all(0),
                          value: controller.showContactNumber.value,
                          onChanged: (value) =>
                              controller.showContactNumber.value = value,
                          title: const Text('Show contact number'),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Location',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        TextField(
                          readOnly: true,
                          onTap: controller.chooseCity,
                          controller: TextEditingController(
                              text: controller.selectedCity.value?.name ?? ''),
                          decoration: const InputDecoration(
                            hintText: 'Select Location',
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        Obx(
                          () => DropdownButtonFormField(
                            value: controller.selectedStatus.value,
                            items: controller.statusList
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: (value) =>
                                controller.selectedStatus.value = value!,
                          ),
                        ),
                        const VerticalSpace(height: 30),
                        ElevatedButton(
                          onPressed: controller.submit,
                          child: const Text('POST'),
                        ),
                        const VerticalSpace(height: 24),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
