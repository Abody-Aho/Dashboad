import 'package:get/get.dart';
import '../home/home_page_controller.dart';
import '../orders/orders_supermarket_controller.dart';
import '../products/products_supermarket_controller.dart';
import '../profile/supermarket_profile_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    // Get.lazyPut<UserController>(() => UserController());
    // Get.lazyPut<ManagementSupermarketController>(() => ManagementSupermarketController());
    Get.lazyPut<OrdersSupermarketController>(() => OrdersSupermarketController());
    Get.lazyPut<ProductsSupermarketController>(() => ProductsSupermarketController());
    Get.lazyPut<SupermarketProfileController>(() => SupermarketProfileController());
    // Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
