import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:product_sharing/config/app_theme.dart';
import 'package:product_sharing/core/services/notification_service.dart';
import 'package:product_sharing/core/utils/device_helper.dart';
import 'package:product_sharing/firebase_options.dart';
import 'package:product_sharing/view/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  await GetStorage.init();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      child: GetMaterialApp(
        title: 'Tamizen Network',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
        home: const SplashScreen(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: EdgeInsets.only(
                top: DeviceHelper.statusbarHeight(context),
                bottom: DeviceHelper.bottombarHeight(context),
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
