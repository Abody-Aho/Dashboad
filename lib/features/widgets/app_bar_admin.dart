import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/lang_service.dart';
import '../../routes/app_routes.dart';
import '../admin/admin_chat/admin_chat_page.dart';

class AppBarAdmin extends StatefulWidget {
  const AppBarAdmin({super.key});

  @override
  _AppBarAdminState createState() => _AppBarAdminState();
}

class _AppBarAdminState extends State<AppBarAdmin> {
  void changeLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        // تحسين شكل الزوايا
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.language, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              "choose_language".tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.greenAccent), // خط فاصل أنيق

              // خيار اللغة العربية
              _buildLanguageOption(
                context: context,
                title: "العربية",
                localeCode: "ar",
                icon: Icons.translate_rounded,
                isSelected: Get.locale?.languageCode == "ar",
              ),

              const SizedBox(height: 8),

              // خيار اللغة الإنجليزية
              _buildLanguageOption(
                context: context,
                title: "English",
                localeCode: "en",
                icon: Icons.abc_rounded,
                isSelected: Get.locale?.languageCode == "en",
              ),
            ],
          ),
        ),
        // إضافة زر إغلاق بسيط
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("close".tr, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

// دالة مساعدة لبناء العناصر بتصميم موحد (Clean Code)
  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String localeCode,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.green[800] : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () async {
          Get.updateLocale(Locale(localeCode));
          await LangService.saveLang(localeCode);
          Navigator.pop(context);
        },
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: Row(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              margin: const EdgeInsets.all(Constants.kPadding),
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Constants.shadow,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Constants.backgroundDark,
                radius: 30,
                child: Image.asset("images/mapp.png"),
              ),
            )
          else
            IconButton(
              color: Constants.primary,
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),

          const SizedBox(width: Constants.kPadding),

          if (ResponsiveLayout.isComputer(context))
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.primary,
                side: const BorderSide(color: Constants.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Constants.kPadding / 2),
                child: Text("admin_panel".tr),
              ),
            ),

          const Spacer(),

          IconButton(
            color: Constants.primary,
            iconSize: 28,
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: Icon(Icons.language, color: Constants.primary, size: 28),
            onPressed: () => changeLanguageDialog(context),
          ),

          Stack(
            children: [
              IconButton(
                color: Constants.primary,
                iconSize: 28,
                onPressed: () {
                  Get.toNamed(AppRoutes.adminChat);
                },
                icon: const Icon(Icons.notifications_none_outlined),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  backgroundColor: Constants.error,
                  radius: 8,
                  child: const Text(
                    "3",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          if (!ResponsiveLayout.isPhone(context))
            Container(
              margin: const EdgeInsets.all(Constants.kPadding),
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Constants.shadow,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Constants.background,
                radius: 30,
                backgroundImage: AssetImage("images/profile.png"),
              ),
            ),
        ],
      ),
    );
  }
}
