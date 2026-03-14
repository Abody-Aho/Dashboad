
import 'package:get/get.dart';

import '../home/home_page_controller.dart';
import '../products/products_supermarket_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomePageController>(() => HomePageController());
    // Get.lazyPut<UserController>(() => UserController());
    // Get.lazyPut<ManagementSupermarketController>(() => ManagementSupermarketController());
    // Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProductsSupermarketController>(() => ProductsSupermarketController());
    // Get.lazyPut<PaymentController>(() => PaymentController());
    // Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
