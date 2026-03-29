import 'dart:convert';
import 'package:dashbord2/core/constants/app_link.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../auth/auth_controller.dart';

class PanelController extends GetxController {
  var totalSold = 0.obs;
  var percentage = 0.0.obs;
  var isLoading = false.obs;

  var topProducts = <Map<String, dynamic>>[].obs;
  var chartData = <Map<String, dynamic>>[].obs;

  int? supermarketId;

  @override
  void onInit() {
    super.onInit();

    //  هنا نجيب ID من الاوث
    final auth = Get.find<AuthController>();
    supermarketId = auth.currentUser.value?.id;

    fetchAllData();

    //  تحديث كل دقيقة
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 60));
      await fetchAllData();
      return true;
    });
  }

  //  جلب كل البيانات
  Future<void> fetchAllData() async {
    await Future.wait([
      getData(),
      getChartData(),
      getTopProducts(),
    ]);
  }

  //  إجمالي المبيعات
  Future<void> getData() async {
    try {
      isLoading.value = true;

      String url = AppLink.getSoldPercentage;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          totalSold.value = data['total_sold'];
          percentage.value =
              (data['percentage'] as num).toDouble();
        }
      }
    } catch (e) {
      print("Error getData: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //  الشارت
  Future<void> getChartData() async {
    try {
      String url = AppLink.getSalesChart;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          chartData.value =
              List<Map<String, dynamic>>.from(data['data'])
                  .map((e) => {
                "month": double.parse(e['month'].toString()),
                "total_sold":
                double.parse(e['total_sold'].toString()),
              })
                  .toList();
        }
      }
    } catch (e) {
      print("Chart Error: $e");
    }
  }

  //  أفضل المنتجات
  Future<void> getTopProducts() async {
    try {
      String url = AppLink.getTopProducts;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          topProducts.value =
              List<Map<String, dynamic>>.from(data['data'])
                  .map((e) => {
                "name": e['itmes_name_ar'],
                "sold": double.parse(e['sold'].toString()),
              })
                  .toList();
        }
      }
    } catch (e) {
      print("Top Products Error: $e");
    }
  }
}