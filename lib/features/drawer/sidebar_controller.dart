import 'package:dashbord2/features/admin/home/home_page.dart';
import 'package:dashbord2/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../admin/management_supermarket/mangmant_supermarket_page.dart';
import '../admin/notifications/notifications_page.dart';
import '../admin/orders/orders_page.dart';
import '../admin/payment/payment_page.dart';
import '../admin/products/products_page.dart';
import '../admin/users/users_page.dart';

class SidebarController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    HomePage(),
    UsersPage(),
    ManagementSupermarketPage(),
    OrdersPage(),
    ProductsPage(),
    PaymentPage(),
    NotificationsPage(),
  ];

  Widget get currentPage => pages[selectedIndex.value];

  /// --- تسجيل الخروج ---
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
