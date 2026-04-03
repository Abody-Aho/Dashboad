import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';
// admin
class PanelCenterController extends GetxController {

  var totalProducts = 0.obs;
  var availableProducts = 0.obs;
  var percentage = 0.0.obs;
  var totalQuantity = 0.obs;
  var chartData = <Map<String, dynamic>>[].obs;

  var isLoading = false.obs;

  Future<void> getProductsStats() async {
    isLoading.value = true;
    try {
      final url = Uri.parse(AppLink.getProductsStats);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          totalProducts.value = data['total'] ?? 0;
          availableProducts.value = data['available'] ?? 0;
          percentage.value = (data['percentage'] ?? 0).toDouble();
          totalQuantity.value = data['total_quantity'] ?? 0;
        }
      }
    } catch (e) {
      print("Exception: $e");
    }
    isLoading.value = false;
  }

  Future<void> getChartData() async {
    try {
      final response = await http.get(Uri.parse(AppLink.ordersChart));
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        chartData.value = List<Map<String, dynamic>>.from(data['data']);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    getProductsStats();
    getChartData();
  }
}