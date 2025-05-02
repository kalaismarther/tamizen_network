import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:product_sharing/model/category/category_model.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:product_sharing/view/widgets/vertical_space.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key,
      required this.category,
      this.listView = false,
      required this.onTap});

  final CategoryModel category;
  final bool listView;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: listView
          ? ListTile(
              contentPadding: EdgeInsets.only(bottom: 16.sp, right: 8.sp),
              leading: OnlineImage(
                link: category.imageUrl,
                height: 48.sp,
                width: 48.sp,
                radius: 0,
                shape: BoxShape.circle,
              ),
              title: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 16.sp,
              ),
            )
          : Column(
              children: [
                OnlineImage(
                  link: category.imageUrl,
                  height: 54.sp,
                  width: 54.sp,
                  radius: 0,
                  shape: BoxShape.circle,
                ),
                const VerticalSpace(height: 10),
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
    );
  }
}
