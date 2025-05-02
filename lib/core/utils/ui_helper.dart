import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UiHelper {
  static void showLoadingDialog() => Get.dialog(
        const PopScope(
          canPop: false,
          child: Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );

  static void closeLoadingDialog() =>
      Get.isDialogOpen == true ? Get.back() : null;

  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  static void showToast(String message, {Color bgColor = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  static String getMsgFromException(String error) {
    final message = error.replaceFirst('Exception: ', '');
    return message;
  }

  static void showErrorMessage(String error) {
    final message = getMsgFromException(error);
    showToast(message);
  }
}
