import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/admin/views/admin_dashboard_view.dart';
import 'features/admin/views/users_view.dart';
import 'features/auth/login_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    ScreenUtilInit(designSize: Size(375, 812), builder: (_, child) => MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Updated Dashboard',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
        canvasColor: Constants.background,
      ),
      initialRoute: '/dashboard',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/admin', page: () => AdminDashboardView()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
