
class AppLink {
  // static const String server = 'http://46.101.225.45/flymarket/dashboard/';
  static const String server = 'http://localhost/flymarket_php_api/dashboard/';
   // static const String image = 'http://46.101.225.45/flymarket/app/customer/upload/supermarket/';
   static const String image = 'http://localhost/flymarket_php_api/app/customer/upload/supermarket/';

  static const String login = '${server}auth/login.php';
  static const String signup = '${server}auth/signup.php';
  static const String status = '${server}admin/user_management/toggle_status.php';
  static const String delete = '${server}admin/user_management/delete_account.php';
  static const String searchUsers = '${server}admin/user_management/search_users.php';
  static const String viewUsers = '${server}admin/user_management/view.php';
  static const String createAccount = '${server}admin/user_management/create_account.php';
  static const String updateAccount = '${server}admin/user_management/update_account.php';
  static const String ordersView = '${server}admin/orders/list.php';



}
