import 'dart:convert';
import 'package:dashbord2/core/constants/app_link.dart';
import 'package:dashbord2/features/admin/users/user_api.dart';
import 'package:dashbord2/features/admin/users/user_dialogs.dart';
import 'package:dashbord2/features/admin/users/user_form.dart';
import 'package:dashbord2/features/admin/users/user_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


// وحدة تحكم المستخدمين - User Controller
class UserController extends GetxController with UserApi, UserForm, UserTable, UserDialogs {

  final searchTextController = TextEditingController();
  @override
  UserController get controller => this;


  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  // ======================= API =======================
  @override
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(AppLink.viewUsers),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List users = body['data'];

          dataList.assignAll(
            users.map<Map<String, String>>((user) {
              return {
                'id': user['id']?.toString() ?? '',
                'role_raw': user['role']?.toString() ?? '',
                'image': user['image']?.toString() ?? '',
                'name_ar': user['name_ar']?.toString() ?? '',
                'name': user['name']?.toString() ?? '',
                'vehicle_number': user['vehicle_number']?.toString() ?? '',
                'supermarket_location':
                user['supermarket_location']?.toString() ?? '',
                'supermarket_time_open':
                user['supermarket_time_open']?.toString() ?? '',

                'Column1': user['role'] == 'supermarket'
                    ? user['name_ar']?.toString() ?? ''
                    : user['name']?.toString() ?? '',

                'Column2': user['email']?.toString() ?? '-',
                'Column3': user['phone']?.toString() ?? '-',
                'Column4': user['role']?.toString() ?? '',
                'Column5': user['status'].toString() == '1'
                    ? 'active'.tr
                    : 'inactive'.tr,
                'Column6': _formatDate(user['created_at']?.toString()),
              };
            }).toList(),
          );

          filteredDataList.assignAll(dataList);
          selectedRows.assignAll(
            List.generate(filteredDataList.length, (_) => false),
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'No internet connection');
    } finally {
      isLoading.value = false;
    }
  }
  // ======================= DATE FORMAT =======================
  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first;
  }



  // ======================= FILTER =======================
  final selectedValue = 'all_types'.obs;
  final options = ['all_types', 'admin', 'users', 'driver', 'supermarket'];



  void filterByType(String value) {
    selectedValue.value = value;

    if (value == 'all_types') {
      filteredDataList.assignAll(dataList);
    } else {
      filteredDataList.assignAll(
        dataList.where((item) {
          final role = item['Column4']?.toLowerCase();
          return role == value;
        }).toList(),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );
  }

  void resetUserDialogState() {

    /// ====== TEXT CONTROLLERS ======
    nameController.clear();
    nameArController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    locationController.clear();
    timeOpenController.clear();
    vehicleController.clear();

    /// ====== ROLE ======
    selectedRole.value = null;

    /// ====== IMAGE ======
    imageBytes = null;
    imageName = null;

    /// ====== PASSWORD VISIBILITY ======
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;

    /// ====== SEARCH ======
    searchTextController.clear();

    /// ====== TABLE SELECTION ======
    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );

    update(); // لتحديث GetBuilder
  }


}
