import 'package:dashbord2/features/auth/auth_binding.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/admin/admin_dashboard/admin_dashboard.dart';
import '../features/admin/admin_dashboard/dashboard_binding.dart';
import '../features/auth/login_view.dart';
import '../features/auth/singin_view.dart';
import '../features/supermarket/views/market_dashboard_view.dart';
import 'app_routes.dart';

class AppPages {
  static final routes =
    [
      GetPage(name: AppRoutes.login, page: () => const LoginScreen(),binding: AuthBinding()),
      GetPage(name: AppRoutes.signIn, page: () => const SignInView(),binding: AuthBinding()),
      GetPage(name: AppRoutes.dashboardMarket, page: () => const MarketDashboardView()),
      GetPage(name: AppRoutes.dashboardAdmin, page: () => const AdminDashboard(),binding: DashboardBinding()),
    ];

}
