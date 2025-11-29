import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/lang_service.dart';

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  void changeLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("choose_language".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("العربية"),
              onTap: () async {
                Get.updateLocale(const Locale("ar"));
                await LangService.saveLang("ar");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("English"),
              onTap: () async {
                Get.updateLocale(const Locale("en"));
                await LangService.saveLang("en");
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
                onPressed: () {},
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
