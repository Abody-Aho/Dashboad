import 'package:get/get.dart';
import 'package:dashbord2/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToLogin();
  }

  void _navigateToLogin() async {

    await Future.delayed(const Duration(milliseconds: 3500));
    Get.offNamed(AppRoutes.login);
  }
}