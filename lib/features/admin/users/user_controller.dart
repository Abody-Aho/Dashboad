import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';


// وحدة تحكم المستخدمين - User Controller
class UserController extends GetxController {
  var dataList = <Map<String, String>>[].obs;
  final _auth = FirebaseAuth.instance;
  var filteredDataList = <Map<String, String>>[].obs;

  RxList<bool> selectedRows = <bool>[].obs;
  RxBool isLoading = true.obs;

  RxInt sortColumnIndex = 0.obs;
  RxBool sortAscending = true.obs;
  final searchTextController = TextEditingController();

  //  الحقول

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameArController = TextEditingController();

  // حقول خاصة بكل دور
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final timeOpenController = TextEditingController();


  //  حالات الواجهة

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;



  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }


  Future<void> addAccount() async {
    if (selectedRole.value == null) {
      Get.snackbar("تنبيه", "يرجى اختيار الرتبة أولاً");
      return;
    }

    String role = selectedRole.value!;
    isLoading.value = true;

    try {
      String? uid;

      // 1. التعامل مع Firebase (فقط للأدمن والسوبرماركت)
      if (role == "admin" || role == "supermarket") {
        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
          throw "البريد وكلمة المرور مطلوبان لهذا النوع";
        }
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
        uid = credential.user!.uid;
      }

      // 2. استدعاء الـ API الجديد الذي أنشأناه بالأعلى
      final response = await ApiServices.adminAddUser(
        role: role,
        name: nameController.text.trim(),
        name_ar: nameArController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        firebaseUid: uid,
        location: locationController.text.trim(),
        timeOpen: timeOpenController.text.trim(),
       // vehicleNumber: "12345", // يمكنك إضافة controller خاص برقم المركبة للمندوب
      );

      if (response['status'] == 'success') {
        Get.back(); // إغلاق النافذة
        await fetchUsers(); // تحديث الجدول
        Get.snackbar("تم", "تمت إضافة $role بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        _clearInputs(); // دالة لتنظيف الحقول
      } else {
        // تراجع عن Firebase في حال فشل قاعدة البيانات
        if (uid != null) await _auth.currentUser?.delete();
        Get.snackbar("خطأ", response['message']);
        print(response['message']);
      }

    } catch (e) {
      Get.snackbar("خطأ", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _clearInputs() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    locationController.clear();
    timeOpenController.clear();
  }

  // ======================= DATA CELLS =======================
  List<DataCell> getDataCells(Map<String, dynamic> data) {
    return [
      _textCell(data['Column1'], 180), // الاسم
      _textCell(data['Column2'], 220), // الإيميل
      _textCell(data['Column3'], 140), // الهاتف
      _textCell(data['Column4'], 140), // الدور
      _statusCell(data['Column5']),    // الحالة
      _textCell(data['Column6'], 150), // تاريخ الإنشاء (بدون ساعة)
      _actionCell(data,data['Column5']),               // العمليات
    ];
  }

  // ======================= HELPERS =======================
  DataCell _textCell(String? text, double width) {
    return DataCell(
      Tooltip(
        message: text ?? '-',
        child: SizedBox(
          width: width,
          child: Text(
            text ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  DataCell _statusCell(String? status) {
    final bool isActive = status == 'active'.tr;
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.green.shade800 : Colors.red.shade800,
          ),
        ),
      ),
    );
  }

  DataCell _actionCell(Map<String, dynamic> data,String? status) {
    final bool isActive = status == 'active'.tr;
    return DataCell(
      SizedBox(
        width: 100, // عرض ثابت للأزرار
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: IconButton(
                icon: Icon(isActive ? Icons.person : Icons.person_off, color: Colors.grey, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => toggleUserStatus(data),
                tooltip: 'View'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('Edit ${data['Column1']}'),
                tooltip: 'Edit'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('Delete ${data['Column1']}'),
                tooltip: 'Delete'.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> toggleUserStatus(Map<String, dynamic> user) async {
    final id = user["id"];
    final role = user["role_raw"]; // تأكد أنك تستخدم role_raw
    final isActive = user["Column5"] == "active".tr;

    final newStatus = isActive ? "0" : "1";

    try {
      final response = await http.post(
        Uri.parse(
            "http://46.101.225.45/flymarket/dashboard/admin/user_management/toggle_status.php"),
        body: {
          "id": id,
          "status": newStatus,
          "role": role,
        },
      );

      print("RESPONSE => ${response.body}");

      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        user["Column5"] =
        newStatus == "1" ? "active".tr : "inactive".tr;

        filteredDataList.refresh();
      } else {
        Get.snackbar("خطأ", body["message"] ?? "فشل التحديث");
      }
    } catch (e) {
      Get.snackbar("خطأ", "مشكلة في الاتصال");
    }
  }



  // ======================= TABLE COLUMNS =======================
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('name'.tr),
      onSort: (i, a) => sortData(0, a),
    ),
    DataColumn(
      label: Text('user_email'.tr),
      onSort: (i, a) => sortData(1, a),
    ),
    DataColumn(
      label: Text('phone'.tr),
      onSort: (i, a) => sortData(2, a),
    ),
    DataColumn(
      label: Text('type'.tr),
      onSort: (i, a) => sortData(3, a),
    ),
    DataColumn(
      label: Text('status'.tr),
      onSort: (i, a) => sortData(4, a),
    ),
    DataColumn(
      label: Text('registration_date'.tr),
      onSort: (i, a) => sortData(5, a),
    ),
    DataColumn(label: Text('actions'.tr)),
  ];

  // ======================= SORT =======================
  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    final key = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final aVal = a[key] ?? '';
      final bVal = b[key] ?? '';

      dynamic result;

      if (columnIndex == 2) {
        final aNum = int.tryParse(aVal) ?? 0;
        final bNum = int.tryParse(bVal) ?? 0;
        result = aNum.compareTo(bNum);
      }

      else if (columnIndex == 5) {
        final aDate = DateTime.tryParse(aVal) ?? DateTime(2000);
        final bDate = DateTime.tryParse(bVal) ?? DateTime(2000);
        result = aDate.compareTo(bDate);
      }

      else {
        result = aVal.toLowerCase().compareTo(bVal.toLowerCase());
      }

      return ascending ? result : -result;
    });

    filteredDataList.refresh();
  }


  // ======================= SEARCH =======================
  Future<void> searchQuery(String query) async {
    if (query.isEmpty) {
      await fetchUsers(); // يرجع البيانات الأصلية
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          "http://46.101.225.45/flymarket/dashboard/admin/user_management/search_users.php?query=${Uri.encodeComponent(query)}",
        ),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          List data = body['data'];

          filteredDataList.assignAll(
            data.map<Map<String, String>>((user) {
              return {
                'Column1': user['name']?.toString() ?? '',
                'Column2': user['email']?.toString() ?? '-',
                'Column3': user['phone']?.toString() ?? '-',
                'Column4': user['type']?.toString() ?? '',
                'Column5': 'active'.tr, // مؤقت إذا ما رجع status
                'Column6': '-', // إذا ما رجع تاريخ
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





  // ======================= API =======================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('http://46.101.225.45/flymarket/dashboard/admin/user_management/view.php'),
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
                'Column1': user['name']?.toString() ?? '',
                'Column2': user['email']?.toString() ?? '-',
                'Column3': user['phone']?.toString() ?? '-',
                'Column4': user['role']?.toString() ?? '',
                'Column5':
                user['status'].toString() == '1' ? 'active'.tr : 'inactive'.tr,
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
  final options = ['all_types', 'admin', 'user', 'driver', 'supermarket'];

  final roles = [
    {
      'label': 'مدير النظام',
      'value': 'admin',
      'icon': Icons.admin_panel_settings,
      'color': Colors.red,
    },
    {
      'label': 'مالك سوبرماركت',
      'value': 'supermarket',
      'icon': Icons.store_mall_directory,
      'color': Colors.green,
    },
    {
      'label': 'مندوب',
      'value': 'driver',
      'icon': Icons.delivery_dining,
      'color': Colors.orange,
    },
    {
      'label': 'عميل',
      'value': 'users',
      'icon': Icons.person,
      'color': Colors.blue,
    },
  ];


  var selectedRole = RxnString();
  void setRole(String role) => selectedRole.value = role;


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


  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }
}
