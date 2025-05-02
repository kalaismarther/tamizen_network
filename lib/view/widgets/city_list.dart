import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/controller/auth/city_list_controller.dart';

class CityList extends StatelessWidget {
  const CityList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CityListController>(
      init: CityListController(),
      builder: (controller) => Container(
        padding: EdgeInsets.all(16.sp),
        height: 400.sp,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                controller.searchCity.value = value.trim();
                controller.getCities();
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.sp),
                  child: Image.asset(
                    AppImages.searchIcon,
                    color: Colors.grey,
                    height: 20.sp,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(maxHeight: 24.sp),
              ),
            ),
            Obx(
              () => Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : controller.error.value != null
                        ? Center(
                            child: Text(controller.error.value!),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            itemCount: controller.cityList.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Get.back(
                                  result: controller.cityList[index],
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.sp),
                                child: Text(
                                  controller.cityList[index].name.toUpperCase(),
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
