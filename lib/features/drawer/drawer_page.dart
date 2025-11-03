import 'package:dashbord2/features/drawer/sidebar_controller.dart';
import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';

class ButtonsInfo {
  String title;
  IconData icon;

  ButtonsInfo({required this.title, required this.icon});
}

final List<ButtonsInfo> buttonsInfo = [
  ButtonsInfo(title: "الرئيسية", icon: Icons.home),
  ButtonsInfo(title: "إدارة المستخدمين", icon: Icons.people),
  ButtonsInfo(title: "إدارة السوبرماركت", icon: Icons.store),
  ButtonsInfo(title: "إدارة الطلبات", icon: Icons.shopping_bag),
  ButtonsInfo(title: "إدارة المنتجات", icon: Icons.inventory_2),
  ButtonsInfo(title: "إدارة الدفع", icon: Icons.payment),
  ButtonsInfo(title: "الإشعارات", icon: Icons.notifications),
  ButtonsInfo(title: "تسجيل الخروج", icon: Icons.logout),
];

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SidebarController ctrl = Get.find<SidebarController>();

    return Drawer(
      backgroundColor: Colors.green[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.kPadding),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  "Admin Menu",
                  style: TextStyle(color: Constants.text),
                ),
                trailing: ResponsiveLayout.isComputer(context)
                    ? null
                    : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Constants.primary),
                ),
              ),

              // القائمة الديناميكية
              Obx(
                    () => Column(
                  children: List.generate(
                    buttonsInfo.length,
                        (index) => Column(
                      children: [
                        Container(
                          decoration: ctrl.selectedIndex.value == index
                              ? BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade200,
                                Colors.green.shade50,
                              ],
                            ),
                          )
                              : null,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              buttonsInfo[index].title,
                              style: TextStyle(color: Constants.text),
                            ),
                            leading: Icon(
                              buttonsInfo[index].icon,
                              color: Constants.primary,
                            ),
                            onTap: () {
                              ctrl.selectedIndex.value = index;
                              if (!ResponsiveLayout.isComputer(context)) Navigator.pop(context);
                            },
                          ),
                        ),
                        Divider(
                          color: Constants.primary,
                          thickness: 0.1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
