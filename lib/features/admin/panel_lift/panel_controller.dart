import 'dart:convert';
import 'package:dashbord2/core/constants/app_link.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// admin
class PanelController extends GetxController {
  var totalSold = 0.obs;
  var percentage = 0.0.obs;
  var isLoading = false.obs;

  var topProducts = <Map<String, dynamic>>[].obs;

  var chartData = <Map<String, dynamic>>[].obs;

  int? supermarketId;

  @override
  void onInit() {
    fetchAllData();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 60));
      await fetchAllData();
      return true;
    });

    super.onInit();
  }

  //  جلب كل البيانات مرة واحدة
  Future<void> fetchAllData() async {
    await Future.wait([
      getData(),
      getChartData(),
      getTopProducts(),
    ]);
  }


  //  إجمالي المبيعات + النسبة
  Future<void> getData() async {
    try {
      isLoading.value = true;

      String url = AppLink.getSoldPercentage;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );

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


  //  بيانات الشارت
  Future<void> getChartData() async {
    try {
      String url = AppLink.getSalesChart;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {

          List rawData = data['data'];

          Map<int, double> monthMap = {};

          for (var e in rawData) {
            int month = int.parse(e['month'].toString());
            double total = double.parse(e['total_sold'].toString());
            monthMap[month] = total;
          }

          List<Map<String, dynamic>> fullData = [];

          for (int i = 1; i <= 12; i++) {
            fullData.add({
              "month": i.toDouble(),
              "total_sold": monthMap[i] ?? 0.0,
            });
          }

          chartData.value = fullData;
        }
      }
    } catch (e) {
      print("Chart Error: $e");
    }
  }

  Future<void> getTopProducts() async {
    try {
      String url = AppLink.getTopProducts;

      if (supermarketId != null) {
        url += "?supermarket_id=$supermarketId";
      }

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "X-API-KEY": "aX9#pL@2026",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          topProducts.value =
              List<Map<String, dynamic>>.from(data['data'])
                  .map((e) => {
                "name": e['itmes_name_ar'],
                "sold":
                double.parse(e['sold'].toString()),
              })
                  .toList();
        }
      }
    } catch (e) {
      print("Top Products Error: $e");
    }
  }
}