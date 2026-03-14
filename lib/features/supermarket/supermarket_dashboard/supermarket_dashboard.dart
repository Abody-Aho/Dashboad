import 'package:dashbord2/features/widgets/app_bar_supermarket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/responsive_layout.dart';
import '../drawer/drawer_supermarket_page.dart';
import '../drawer/sidebar_supermarket_controller.dart';

class SupermarketDashboard extends StatelessWidget {
  const SupermarketDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarSupermarketController ctrl = Get.put(SidebarSupermarketController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child:
        ResponsiveLayout.isTinyLimit(context) ||
            ResponsiveLayout.isTinyHeightLimit(context)
            ? Container()
            : AppBarSupermarket(),
      ),
      body: Obx(
            () => ResponsiveLayout(
          tiny: Container(),
          phone: ctrl.currentPage,
          tablet: Row(children: [Expanded(child: ctrl.currentPage)]),
          largeTablet: Row(children: [Expanded(child: ctrl.currentPage)]),
          computer: Row(
            children: [
              SizedBox(width: 350, child: DrawerSupermarketPage()),
              Expanded(child: ctrl.currentPage),
            ],
          ),
        ),
      ),
      drawer: ResponsiveLayout.isComputer(context) ? null : DrawerSupermarketPage(),
    );
  }
}
