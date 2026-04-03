import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/routes/app_pages.dart';
import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/lang/translations.dart';
import 'core/services/lang_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/auth_binding.dart';
import 'features/auth/auth_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAoK7_-KbIPfV_U2J5qtIDXh8bN_SyEv14",
      authDomain: "flymarket-34847.firebaseapp.com",
      projectId: "flymarket-34847",
      storageBucket: "flymarket-34847.firebasestorage.app",
      messagingSenderId: "571768389468",
      appId: "1:571768389468:web:2261fae6418bddbd6e0b99",
    ),
  );

  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onMessageOpenedApp.listen((message) {

  });

  String? token = await FirebaseMessaging.instance.getToken(
    vapidKey: "BIMaxXuMXgoEhOrL8yRxs_XnNanF1TgnCQsHWNJEX4c19keSYCnaVR4fx9usP0fGnnzfIkHYdunp6Tm7Km1DMMw",
  );

  print("FCM TOKEN: $token");

  FirebaseMessaging.onMessage.listen((message) {

    Get.snackbar(
      message.notification?.title ?? "إشعار",
      message.notification?.body ?? "",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      onTap: (snack) {

        String page = message.data["pagename"];

        if (page == "chat") {

          final auth = Get.find<AuthController>();

          if (auth.currentUser.value?.role == "admin") {

            Get.toNamed(AppRoutes.adminChat, arguments: {
              "room_id": message.data["pageid"]
            });

          } else {

            Get.toNamed(AppRoutes.marketChat, arguments: {
              "room_id": message.data["pageid"]
            });
          }
        }
      }
    );

  });



  await GetStorage.init();

  Locale locale = await LangService.getSavedLocale();

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, _) => MyApp(locale: locale),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Updated Dashboard',
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('ar'),
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        canvasColor: Constants.background,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 1000),
    );
  }
}
