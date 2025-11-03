import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../drawer/sidebar_controller.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.put(SidebarController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة الطلبات"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("إدارة الطلبات"),
      ),
    );
  }
}
