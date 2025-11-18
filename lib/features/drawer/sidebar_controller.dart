import 'package:dashbord2/features/admin/views/admin_dashboard_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../auth/login_view.dart';
import '../management_supermarket/mangmant_supermarket_page.dart';
import '../users/users_page.dart';
import '../orders/orders_page.dart';
import '../products/products_page.dart';
import '../payment/payment_page.dart';
import '../notifications/notifications_page.dart';

class SidebarController extends GetxController {
  var selectedIndex = 0.obs;

  final List<Widget> pages = [
    AdminDashboardView(),
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
