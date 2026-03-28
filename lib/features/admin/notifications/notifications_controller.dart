import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'notifications_api.dart';
import 'notifications_dialogs.dart';
import 'notifications_helpers.dart';
import 'notifications_table.dart';

class NotificationsController extends GetxController
    with
        NotificationsApi,
        NotificationsDialogs,
        NotificationsTable,
        NotificationsHelpers {
  @override
  NotificationsController get controller => this;
  var dataList = <Map<String, String>>[].obs;
  var filteredDataList = <Map<String, String>>[].obs;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  Uint8List? bannerImageBytes;
  String? bannerImageName;

  var bannerLoading = false.obs;

  var selectedType = "general".obs;
  var selectedReceivers = "users".obs;

  RxList<bool> selectedRows = <bool>[].obs;

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;

  final searchTextController = TextEditingController();

  var isLoading = false.obs;
  var banners = [].obs;
  var bannerIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  final selectedValue = 'all_types'.obs;

  final options = ['all_types', 'offer', 'order', 'update', 'alert', 'general'];

  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  final selectedWay = 'all_statuses'.obs;

  final List<String> paymentWay = ['all_statuses', 'sent', 'pending', 'failed'];

  void changeWay(String newValue) {
    selectedWay.value = newValue;
  }
}
