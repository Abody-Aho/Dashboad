import 'package:get/get.dart';
import '../../management_supermarket/mangmant_supermarket_page.dart';
import '../../notifications/notifications_page.dart';
import '../../orders/orders_page.dart';
import '../../payment/payment_page.dart';
import '../../products/products_page.dart';
import '../../users/users_page.dart';
import '../views/admin_dashboard_view.dart';

class AdminDashboardController extends GetxController {
  // المؤشر الحالي للقائمة
  var selectedIndex = 0.obs;

  // الصفحات اللي بيتم التنقل بينها
  final pages = [
    const AdminDashboardView(),
    const UsersPage(),
    const ManagementSupermarketPage(),
    const OrdersPage(),
    const ProductsPage(),
    const PaymentPage(),
    const NotificationsPage(),
    const AdminDashboardView(), // مؤقت لتسجيل الخروج
  ];
}
