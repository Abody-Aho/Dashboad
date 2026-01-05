import 'package:get/get.dart';
import '../home/home_page_controller.dart';
import '../management_supermarket/mangmant_supermarket_controller.dart';
import '../notifications/notifications_controller.dart';
import '../orders/orders_controller.dart';
import '../payment/payment_controller.dart';
import '../products/products_controller.dart';
import '../users/user_controller.dart';
import 'supermarket_dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupermarketDashboardController>(() => SupermarketDashboardController());
    Get.lazyPut<HomePageController>(() => HomePageController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<ManagementSupermarketController>(() => ManagementSupermarketController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProductsController>(() => ProductsController());
    Get.lazyPut<PaymentController>(() => PaymentController());
    Get.lazyPut<NotificationsController>(() => NotificationsController());
  }
}
