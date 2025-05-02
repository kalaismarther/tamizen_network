import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_sharing/config/app_images.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/model/post/requested_customer_model.dart';
import 'package:product_sharing/view/widgets/horizontal_space.dart';
import 'package:product_sharing/view/widgets/online_image.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestedCustomerItem extends StatelessWidget {
  const RequestedCustomerItem({super.key, required this.customer});

  final RequestedCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      leading: OnlineImage(
        link: customer.profileImageUrl,
        height: 54.sp,
        width: 54.sp,
        radius: 0,
        shape: BoxShape.circle,
      ),
      title: Text(
        customer.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          Image.asset(
            AppImages.locationIconWhite,
            color: AppTheme.blue,
            height: 16.sp,
          ),
          const HorizontalSpace(width: 6),
          Text(
            customer.cityName,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              try {
                launchUrl(Uri(scheme: 'tel', path: customer.mobile));
              } catch (e) {
                //
              }
            },
            icon: Image.asset(
              AppImages.phone,
              height: 30.sp,
            ),
          ),
          IconButton(
            onPressed: () {
              try {
                launchUrl(Uri(scheme: 'mailto', path: customer.email));
              } catch (e) {
                //
              }
            },
            icon: Image.asset(
              AppImages.mail,
              height: 30.sp,
            ),
          )
        ],
      ),
    );
  }
}
