import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_sharing/view/widgets/loading_shimmer.dart';

import 'package:product_sharing/view/widgets/vertical_space.dart';

class LoadingPostItem extends StatelessWidget {
  const LoadingPostItem({super.key, this.showInList = false});

  final bool showInList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: showInList ? 180.sp : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(
            height: 160.sp,
            width: double.infinity,
            radius: 16.sp,
          ),
          const VerticalSpace(height: 12),
          LoadingShimmer(
            height: 16.sp,
            width: 100.sp,
            radius: 8,
          ),
          const VerticalSpace(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoadingShimmer(
                height: 16.sp,
                width: 60.sp,
                radius: 8,
              ),
              LoadingShimmer(
                height: 16.sp,
                width: 60.sp,
                radius: 8,
              ),
            ],
          )
        ],
      ),
    );
  }
}
