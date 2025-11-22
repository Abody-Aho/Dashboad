import 'package:dashbord2/features/admin/home/home_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../admin/management_supermarket/mangmant_supermarket_page.dart';
import '../admin/notifications/notifications_page.dart';
import '../admin/orders/orders_page.dart';
import '../admin/payment/payment_page.dart';
import '../admin/products/products_page.dart';
import '../admin/users/users_page.dart';
import '../auth/login_view.dart';

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
    LoginScreen(),
  ];

  Widget get currentPage => pages[selectedIndex.value];
}
