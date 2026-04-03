import 'package:dashbord2/features/auth/auth_binding.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../features/admin/admin_chat/admin_chat_binding.dart';
import '../features/admin/admin_chat/admin_chat_page.dart';
import '../features/admin/admin_dashboard/admin_dashboard.dart';
import '../features/admin/admin_dashboard/dashboard_binding.dart'
    as admin_binding;
import '../features/auth/login_view.dart';
import '../features/auth/singin_view.dart';
import '../features/splash/splash_screen.dart';
import '../features/supermarket/supermarket_chat/supermarket_chat_binding.dart';
import '../features/supermarket/supermarket_chat/supermarket_chat_page.dart';
import '../features/supermarket/supermarket_dashboard/dashboard_binding.dart'
    as market_binding;
import '../features/supermarket/supermarket_dashboard/supermarket_dashboard.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboardMarket,
      page: () => const SupermarketDashboard(),
      binding: market_binding.DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboardAdmin,
      page: () => const AdminDashboard(),
      binding: admin_binding.DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.adminChat,
      page: () =>  AdminChatPage(),
      binding: AdminChatBinding()
    ),
    GetPage(
      name: AppRoutes.marketChat,
      page: () => SupermarketChatPage(),
      binding: SupermarketChatBinding(),
    ),
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
    ),
  ];
}
