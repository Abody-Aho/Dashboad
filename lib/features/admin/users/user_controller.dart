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
  var totalUsers = 0.obs;
  var activeUsers = 0.obs;
  var newUsers = 0.obs;

  var isStatusLoading = false.obs;
  @override
  UserController get controller => this;


  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    fetchStats();
  }

  String clean(dynamic value) {
    if (value == null) return '';
    final v = value.toString().trim();
    if (v.isEmpty || v.toLowerCase() == 'null') return '';
    return v;
  }

  // ======================= API =======================
  @override
  Future<void> fetchUsers({String? role}) async {
    try {
      isLoading.value = true;

      final Map<String, String> query = {};

      if (role != null && role != 'all_types') {
        query['role'] = role;
      }

      final uri = Uri.parse(AppLink.viewUsers).replace(
        queryParameters: query.isEmpty ? null : query,
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          "X-API-KEY": "aX9#pL@2026",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List users = body['data'];

          dataList.assignAll(
            users.map<Map<String, String>>((user) {
              return {
                'id': clean(user['id']),
                'role_raw': clean(user['role']),
                'name': clean(user['name']),
                'name_ar': clean(user['name_ar']),
                'image': clean(user['image']),
                'license': clean(user['license']),
                'rating_avg': clean(user['rating_avg']),
                'vehicle_number': clean(user['vehicle_number']),
                'supermarket_location': clean(user['supermarket_location']),
                'supermarket_time_open': clean(user['supermarket_time_open']),

                'Column4': clean(user['role']),

                'Column1': user['role'] == 'supermarket'
                    ? clean(user['name_ar'])
                    : clean(user['name']),

                'Column2': clean(user['email']),
                'Column3': clean(user['phone']),

                'Column5': user['status'].toString() == '1'
                    ? 'active'.tr
                    : 'inactive'.tr,

                'Column6': _formatDate(clean(user['created_at'])),
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

    searchTextController.clear();
    fetchUsers(role: value);
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
