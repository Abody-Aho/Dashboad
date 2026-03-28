import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import '../../../data/models/notification_model.dart';
import 'notifications_controller.dart';

mixin NotificationsApi on GetxController {
  NotificationsController get controller;

  Future fetchBanners() async {
    try {
      var response = await http.get(Uri.parse(AppLink.bannerView));

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        controller.banners.assignAll(data["data"]);
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteBanner(String id, String image) async {
    try {
      var response = await http.post(
        Uri.parse(AppLink.bannerDelete),
        body: {"id": id, "image": image},
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        controller.showSuccess("banner_deleted".tr);

        fetchBanners();
      }
    } catch (e) {
      print(e);
    }
  }

  /// البحث
  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await controller.fetchNotifications();
      return;
    }

    try {
      controller.isLoading.value = true; // 🔥 مهم

      final response = await http.get(
        Uri.parse("${AppLink.notificationsSearch}?query=${Uri.encodeComponent(query)}"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          List data = body['data'];

          controller.filteredDataList.assignAll(
            data.map<Map<String, String>>((e) {
              return {
                'Column1': e['notification_title'] ?? '',
                'Column2': e['notification_type'] ?? '',
                'Column3': e['notification_receivers'] ?? '',
                'Column4': e['notification_sent_count'].toString(),
                'Column5': e['notification_read_count'].toString(),
                'Column6': "${e['read_rate']}%",
                'Column7': e['notification_status'] ?? '',
                'Column8': e['notification_datetime'].split(" ")[0],
              };
            }).toList(),
          );

          controller.selectedRows.assignAll(
            List.generate(controller.filteredDataList.length, (_) => false),
          );
        } else {
          controller.filteredDataList.clear();
        }
      }
    } catch (e) {
      print("Search Error: $e");
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future uploadBanner() async {
    if (controller.bannerImageBytes == null) {
      controller.showError("choose_image".tr);
      return;
    }

    try {
      controller.bannerLoading.value = true;

      var request = http.MultipartRequest("POST", Uri.parse(AppLink.bannerAdd));

      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          controller.bannerImageBytes!,
          filename: controller.bannerImageName,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        controller.bannerImageBytes = null;
        controller.bannerImageName = null;

        fetchBanners();
        update();

        controller.showSuccess("banner_uploaded".tr);
      } else {
        controller.showError("upload_failed".tr);
      }
    } catch (e) {
      controller.showError("server_error".tr);
    } finally {
      controller.bannerLoading.value = false;
    }
  }

  Future createNotification({
    required String title,
    required String body,
    required String type,
    required String receivers,
  }) async {
    if (title.isEmpty || body.isEmpty) {
      controller.showError("enter_title_body".tr);

      return;
    }

    try {
      controller.isLoading.value = true;

      var response = await http.post(
        Uri.parse(AppLink.notificationsCreate),
        body: {
          "title": title,
          "body": body,
          "type": type,
          "receivers": receivers,
        },
      );

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        Get.back();

        controller.showSuccess("notification_sent".tr);

        fetchNotifications();
      } else {
        controller.showError("something_wrong".tr);
      }
    } catch (e) {
      controller.showError("server_error".tr);
    } finally {
      controller.isLoading.value = false;
    }
  }

  Future fetchNotifications() async {
    try {
      controller.isLoading.value = true;

      var response = await http.get(Uri.parse(AppLink.notificationsView));

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        List list = data["data"];

        controller.dataList.assignAll(
          list.map((e) {
            NotificationModel model = NotificationModel.fromJson(e);

            return {
              'Column1': model.notificationTitle,
              'Column2': model.notificationType ?? "",
              'Column3': model.notificationReceivers ?? "",
              'Column4': model.notificationSentCount.toString(),
              'Column5': model.notificationReadCount.toString(),
              'Column6': "${model.readRate}%",
              'Column7': model.notificationStatus,
              'Column8': model.notificationDatetime.split(" ")[0],
            };
          }).toList(),
        );

        controller.filteredDataList.assignAll(controller.dataList);

        controller.selectedRows.assignAll(
          List.generate(controller.filteredDataList.length, (index) => false),
        );
      }
    } catch (e) {
      print("Notification Error: $e");
    } finally {
      controller.isLoading.value = false;
    }
  }
}
