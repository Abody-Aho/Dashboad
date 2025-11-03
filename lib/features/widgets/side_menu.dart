import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          // header صغير
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('لوحة الأدمن', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                Icon(Icons.dashboard, color: Constants.primary),
              ],
            ),
          ),
          SizedBox(height: 24),

          // القوائم
          _menuItem('نظرة عامة', Icons.home, onTap: () {}),
          _menuItem('إدارة المستخدمين', Icons.people, onTap: () {}),
          _menuItem('إدارة السوبرماركت', Icons.store, onTap: () {}),
          _menuItem('إدارة الطلبات', Icons.shopping_cart, onTap: () {}),
          _menuItem('إدارة المنتجات', Icons.inventory_2, onTap: () {}),
          _menuItem('الإشعارات', Icons.notifications, onTap: () {}),
          Spacer(),
          _menuItem('تسجيل الخروج', Icons.exit_to_app, onTap: () { /* أعمل لوغ آوت */ }),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Constants.primary),
      title: Text(title, style: GoogleFonts.cairo()),
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
