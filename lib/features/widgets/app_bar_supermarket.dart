import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/lang_service.dart';
import '../../core/utils/helpers/language_helper.dart';
import '../../routes/app_routes.dart';
import '../supermarket/profile/supermarket_profile_controller.dart';

class AppBarSupermarket extends StatefulWidget {
  const AppBarSupermarket({super.key});

  @override
  AppBarSupermarketState createState() => AppBarSupermarketState();
}

class AppBarSupermarketState extends State<AppBarSupermarket> {
  final SupermarketProfileController controller = Get.put(SupermarketProfileController());
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
                child: Text("مالك سوبرماركت".tr),
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
            onPressed: () => LanguageHelper.changeLanguageDialog(),
          ),

              IconButton(
                color: Constants.primary,
                iconSize: 28,
                onPressed: () {
                  Get.toNamed(AppRoutes.marketChat);
                },
                icon: const Icon(Icons.notifications_none_outlined),
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
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade100,
                backgroundImage: controller.imageBytes.value != null
                    ? MemoryImage(controller.imageBytes.value!)
                    : (controller.imageUrl.value.isEmpty
                    ? const AssetImage("images/profile.png")
                    : NetworkImage(controller.imageUrl.value))
                as ImageProvider,
              ),
            ),
        ],
      ),
    );
  }
}
