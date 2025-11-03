import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../drawer/sidebar_controller.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.put(SidebarController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة المدفوعات"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("إدارة المدفوعات"),
      ),
    );
  }
}
