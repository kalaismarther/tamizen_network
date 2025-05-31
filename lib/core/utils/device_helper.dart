import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceHelper {
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double statusbarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top + 10;

  static double bottombarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom + 10;

  static Future<Device> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;

      return Device(id: iosInfo.identifierForVendor ?? '', type: 'IOS');
      // return Device(id: '1', type: 'IOS');
    } else {
      var androidInfo = await deviceInfoPlugin.androidInfo;

      return Device(id: androidInfo.id, type: 'ANDROID');
      // return Device(id: '1', type: 'ANDROID');
    }
  }

  static Future<String> getFCM() async {
    final fcm = FirebaseMessaging.instance;
    String? token =
        Platform.isIOS ? await fcm.getAPNSToken() : await fcm.getToken();
    if (kDebugMode) {
      print('FCM TOKEN --- $token');
    }
    return token ?? 'fcmtoken';
  }
}

class Device {
  final String id;
  final String type;

  Device({required this.id, required this.type});
}
