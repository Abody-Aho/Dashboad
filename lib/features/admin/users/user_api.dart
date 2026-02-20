import 'dart:convert';
import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';

mixin UserApi on GetxController {

  var dataList = <Map<String,String>>[].obs;
  var filteredDataList = <Map<String,String>>[].obs;
  var isLoading = false.obs;
  RxList<bool> selectedRows = <bool>[].obs;






// ======================= SEARCH =======================
  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await (this as UserController).fetchUsers();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("${AppLink.searchUsers}?query=${Uri.encodeComponent(query)}"),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          List data = body['data'];

          filteredDataList.assignAll(
            data.map<Map<String, String>>((user) {
              return {
                'id': user['id']?.toString() ?? '',
                'role_raw': user['role']?.toString() ?? '',
                'name': user['name']?.toString() ?? '',

                'Column1': user['name']?.toString() ?? '',
                'Column2': user['email']?.toString() ?? '-',
                'Column3': user['phone']?.toString() ?? '-',
                'Column4': user['role']?.toString() ?? '',
                'Column5': 'active'.tr,
                'Column6': '-',
              };
            }).toList(),
          );

          selectedRows.assignAll(
            List.generate(filteredDataList.length, (_) => false),
          );
        } else {
          filteredDataList.clear();
        }
      }
    } catch (e) {
      print("Search Error: $e");
    }
  }

  Future<void> deleteUserFromServer({
    required String id,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(AppLink.delete),
        body: {"id": id, "role": role},
      );

      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        Get.snackbar(
          "تم",
          "تم حذف المستخدم بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await (this as UserController).fetchUsers();
      } else {
        Get.snackbar(
          "خطأ",
          body["message"] ?? "فشل الحذف",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "مشكلة في الاتصال",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleUserStatus(Map<String, dynamic> user) async {
    final id = user["id"];
    final role = user["role_raw"];
    final isActive = user["Column5"] == "active".tr;

    final newStatus = isActive ? "0" : "1";

    try {
      final response = await http.post(
        Uri.parse(AppLink.status),
        body: {"id": id, "status": newStatus, "role": role},
      );

      print("RESPONSE => ${response.body}");

      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        user["Column5"] = newStatus == "1" ? "active".tr : "inactive".tr;

        filteredDataList.refresh();
      } else {
        Get.snackbar("خطأ", body["message"] ?? "فشل التحديث");
      }
    } catch (e) {
      Get.snackbar("خطأ", "مشكلة في الاتصال");
    }
  }

  List<Map<String, dynamic>> getSelectedUsers() {
    List<Map<String, dynamic>> selectedUsers = [];

    for (int i = 0; i < selectedRows.length; i++) {
      if (selectedRows[i]) {
        selectedUsers.add(filteredDataList[i]);
      }
    }

    return selectedUsers;
  }

  Future<void> changeStatusForSelected(String status) async {
    final selectedUsers = getSelectedUsers();

    if (selectedUsers.isEmpty) {
      Get.snackbar("تنبيه", "لم يتم تحديد أي مستخدم");
      return;
    }

    try {
      isLoading.value = true;

      for (var user in selectedUsers) {
        await http.post(
          Uri.parse(AppLink.status),
          body: {"id": user['id'], "status": status, "role": user['role_raw']},
        );
      }

      await (this as UserController).fetchUsers();

      Get.snackbar("تم", "تم تحديث حالة المستخدمين");
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحديث الجماعي");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSelectedUsers() async {
    final selectedUsers = getSelectedUsers();

    if (selectedUsers.isEmpty) {
      Get.snackbar("تنبيه", "لم يتم تحديد أي مستخدم");
      return;
    }

    try {
      isLoading.value = true;

      for (var user in selectedUsers) {
        await deleteUserFromServer(id: user['id'], role: user['role_raw']);
      }

      selectedRows.assignAll(
        List.generate(filteredDataList.length, (_) => false),
      );

      await (this as UserController).fetchUsers();

      Get.snackbar("تم", "تم حذف المستخدمين المحددين");
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحذف الجماعي");
    } finally {
      isLoading.value = false;
    }
  }





}

