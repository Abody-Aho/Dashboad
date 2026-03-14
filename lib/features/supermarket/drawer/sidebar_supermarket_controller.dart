import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../home/home_page.dart';
import '../products/products_supermarket_page.dart';

class SidebarSupermarketController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    HomePage(),
    // OrdersPage(),
    ProductsSupermarketPage(),
    // PaymentPage(),
    // NotificationsPage(),
    // AdminProfilePage()
  ];

  Widget get currentPage => pages[selectedIndex.value];

  Future<void> logout() async {
    try {
      // تسجيل الخروج من Firebase
      await FirebaseAuth.instance.signOut();
      // التوجيه لشاشة تسجيل الدخول ومسح الصفحات السابقة
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar("خطأ", "فشل تسجيل الخروج: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}
