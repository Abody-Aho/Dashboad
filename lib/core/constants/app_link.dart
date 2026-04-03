
class AppLink {
  static const String server = 'http://46.101.225.45/flymarket/dashboard/';
  // static const String server = 'http://localhost/flymarket_php_api/dashboard/';
   static const String image = 'http://46.101.225.45/flymarket/app/customer/upload/supermarket/';
   static const String imageOrders = 'http://46.101.225.45/flymarket/app/customer/upload/pay/';
   static const String pdf = 'http://46.101.225.45/flymarket/dashboard/admin/upload/licenses/';
  //  static const String image = 'http://localhost/flymarket_php_api/app/customer/upload/supermarket/';

  //======================= Admin =======================
  static const String login = '${server}auth/login.php';
  static const String signup = '${server}auth/signup.php';
  static const String status = '${server}admin/user_management/toggle_status.php';
  static const String delete = '${server}admin/user_management/delete_account.php';
  static const String searchUsers = '${server}admin/user_management/search_users.php';
  static const String ordersSearch = '${server}admin/orders/orders_search.php';
  static const String notificationsSearch = '${server}admin/notification/notifications_search.php';
  static const String viewUsers = '${server}admin/user_management/view.php';
  static const String createAccount = '${server}admin/user_management/create_account.php';
  static const String updateAccount = '${server}admin/user_management/update_account.php';
  static const String ordersView = '${server}admin/orders/list.php';
  static const String itemsAdminView = '${server}admin/items/get_items_admin.php';
  static const String addItem = '${server}admin/items/add.php';
  static const String itemsSearch = '${server}admin/items/search_items.php';
  static const String supersView = '${server}admin/items/supermarketview.php';
  static const String categoriesBySuper = '${server}admin/items/categoriesby_super.php';
  static const String categoriesAll = '${server}admin/items/categoriesallview.php';
  static const String addCategoryAll = '${server}admin/items/add_category_all.php';
  static const String addCategoryPrivate = '${server}admin/items/add_category_private.php';
  static const String updateCategoryAll = '${server}admin/items/update_category_all.php';
  static const String updateCategoryPrivate = '${server}admin/items/update_category_private.php';
  static const String itemsFilter = '${server}admin/items/items_by_category.php';
  static const String imageItems = 'http://46.101.225.45/flymarket/app/customer/upload/items/';
  static const String imageCategories = 'http://46.101.225.45/flymarket/app/customer/upload/categories/';
  static const String updateItem = '${server}admin/items/update_item.php';
  static const String deleteItem = "${server}admin/items/delete_item.php";
  static const String updateStatus = "${server}admin/orders/update_order_status.php";
  static const String deleteOrder = "${server}admin/orders/delete_order.php";
  static const String viewCoupon = "${server}admin/coupon/view.php";
  static const String addCoupon = "${server}admin/coupon/add.php";
  static const String editCoupon = "${server}admin/coupon/edit.php";
  static const String deleteCoupon = "${server}admin/coupon/delete.php";
  static const String orderDetails = "${server}admin/orders/orders_items_view.php";
  static const String notificationsView = "${server}admin/notification/notification_view.php";
  static const notificationsCreate = "${server}admin/notification/create_notification.php";
  static const bannerAdd = "${server}admin/notification/add_banner.php";
  static const bannerDelete = "${server}admin/notification/delete_banner.php";
  static const bannerView = "${server}admin/notification/banner_view.php";
  static const imageBanner = "http://46.101.225.45/flymarket/app/customer/upload/banners/";
  static const updateProfile = "${server}admin/profile/update_profile.php";
  static const getSoldPercentage = "${server}admin/items/get_sold_percentage.php";
  static const getSalesChart = "${server}admin/items/get_curved_chart.php";
  static const getTopProducts = "${server}admin/items/get_top_products.php";
  static const getProductsStats = "${server}admin/items/products_available.php";
  static const ordersChart = "${server}admin/items/orders_chart.php";
  static const usersStats = "${server}admin/user_management/get_users_status.php";
  static const ordersStats = "${server}admin/orders/get_order_statusl.php";
  static const productsStats = "${server}admin/items/get_products_stats.php";
  static const notificationsStats = "${server}admin/notification/get_notifications_stats.php";


  //======================= SuperMarket =======================
  static const itemsSupermarketView = "${server}supermarket/items/get_items.php";
  static const addItemSupermarket = "${server}supermarket/items/add_item.php";
  static const updateItemSupermarket = "${server}supermarket/items/update_item.php";
  static const deleteItemSupermarket = "${server}supermarket/items/delete_item.php";
  static const itemsSearchSupermarket = "${server}supermarket/items/search_items.php";
  static const ordersViewSupermarket = "${server}supermarket/orders/view_orders.php";
  static const ordersViewDetails = "${server}supermarket/orders/orders_items_details.php";
  static const updateStatusSuper = "${server}supermarket/orders/update_order_status_super.php";
  static const deleteSuperOrder = "${server}supermarket/orders/delete_super_order.php";
  static const updateSupermarketProfile = "${server}supermarket/profile/update_super_profile.php";
  static const getOrCreateRoom = "${server}supermarket/supermarket_chat/get_or_create_room.php";
  static const sendMessage = "${server}supermarket/supermarket_chat/send_message.php";
  static const getMessage = "${server}supermarket/supermarket_chat/get_messages.php";
  static const getSupermarkets = "${server}supermarket/supermarket_chat/get_supermarkets.php";
  static const itemsFilterSupermarket = "${server}supermarket/items/items_filter_supermarket.php";
  static const deleteMessage = "${server}supermarket/supermarket_chat/delete_message.php";
  static const saveToken = "${server}save_token.php";



}
