import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../drawer/sidebar_controller.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.put(SidebarController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإشعارات"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("صفحة الإشعارات"),
      ),
    );
  }
}
