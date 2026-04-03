import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';
import '../../auth/auth_controller.dart'; // 🔥 مهم
// spuer
class PanelCenterController extends GetxController {

  // 🔥 البيانات
  var totalProducts = 0.obs;
  var availableProducts = 0.obs;
  var percentage = 0.0.obs;
  var totalQuantity = 0.obs;
  var chartData = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  int? supermarketId;

  @override
  void onInit() {
    super.onInit();

    // 🔥 جلب ID من المستخدم الحالي
    final auth = Get.find<AuthController>();
    supermarketId = auth.currentUser.value?.id;

    fetchAllData();
  }

  // 🔥 جلب كل البيانات
  Future<void> fetchAllData() async {
    await Future.wait([
      getProductsStats(),
      getChartData(),
    ]);
  }

  // 🔥 احصائيات المنتجات
  Future<void> getProductsStats() async {
    isLoading.value = true;

    try {
      String url = AppLink.getProductsStats;

      // 🔥 تمرير ID
      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          totalProducts.value = data['total'] ?? 0;
          availableProducts.value = data['available'] ?? 0;
          percentage.value =
              (data['percentage'] ?? 0).toDouble();
          totalQuantity.value = data['total_quantity'] ?? 0;
        } else {
          print("API Error: ${data['message']}");
        }
      } else {
        print("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }

    isLoading.value = false;
  }

  // 🔥 الشارت
  Future<void> getChartData() async {
    try {
      String url = AppLink.ordersChart;

      // 🔥 تمرير ID
      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      final response = await http.get(Uri.parse(url));

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        chartData.value =
        List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      print(e);
    }
  }
}