import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../drawer/sidebar_controller.dart';

class MangmantSupermarketPage extends StatelessWidget {
  const MangmantSupermarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.put(SidebarController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("إدارة السوبرماركت"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          "صفحة إدارة السوبرماركت",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
