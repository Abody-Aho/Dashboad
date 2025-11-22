import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/admin/admin_dashboard/admin_dashboard.dart';
import '../features/admin/admin_dashboard/dashboard_binding.dart';
import '../features/admin/home/home_page.dart';
import '../features/auth/login_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes =
    [
      GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
      GetPage(name: AppRoutes.admin, page: () => const HomePage()),
      GetPage(name: AppRoutes.dashboard, page: () => const AdminDashboard(),binding: DashboardBinding()),
    ];

}
