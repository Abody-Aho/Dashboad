import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../drawer/drawer_page.dart';
import '../../drawer/sidebar_controller.dart';
import '../../widgets/app_bar_widget.dart';
import '../../widgets/responsive_layout.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.put(SidebarController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: ResponsiveLayout.isTinyLimit(context) ||
            ResponsiveLayout.isTinyHeightLimit(context)
            ? Container()
            : AppBarWidget(),
      ),
      body: Obx(
            () => ResponsiveLayout(
          tiny: Container(),
          phone: ctrl.currentPage,
          tablet: Row(
            children: [
              Expanded(child: ctrl.currentPage),
            ],
          ),
          largeTablet: Row(
            children: [
              Expanded(child: ctrl.currentPage),
            ],
          ),
          computer: Row(
            children: [
              SizedBox(
                width: 350,
                child: DrawerPage(),
              ),
              Expanded(
                child: ctrl.currentPage,
              ),
            ],
          ),
        ),
      ),
      drawer: ResponsiveLayout.isComputer(context) ? null : DrawerPage(),
    );
  }
}
