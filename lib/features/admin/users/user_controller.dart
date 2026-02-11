import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';
import '../../../data/models/user_model.dart';


/// وحدة تحكم المستخدمين - User Controller
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
      Get.snackbar("خطأ", "يرجى اختيار نوع المستخدم", backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    UserCredential? credential;

    try {
      isLoading.value = true;

      credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      final uid = credential.user!.uid;


      final newUser = UserModel(
        firebaseUid: uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        role: selectedRole.value!,
        status: 1,
      );

      final response = await ApiServices.signUp(
        user: newUser,
        location: locationController.text.trim(),
        time_open: timeOpenController.text.trim(),
      );

      if (response['status'] == 'success') {
        await fetchUsers(); // تحديث البيانات من السيرفر
        Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 30),
                const SizedBox(width: 10),
                Text(
                  "تم بنجاح",
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: const Text("تم إضافة الحساب بنجاح"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Get.back(),
                child: const Text("حسناً", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        phoneController.clear();
        selectedRole.value = null;
      } else {
        await credential.user?.delete();
        Get.snackbar("خطأ في الخادم", response['message'] ?? "فشل حفظ البيانات.", backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } on FirebaseAuthException catch (e) {
      String message = "حدث خطأ أثناء إضافة الحساب.";
      if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جدًا (6 أحرف على الأقل).';
      } else if (e.code == 'email-already-in-use') {
        message = 'هذا البريد الإلكتروني مُسجل بالفعل.';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة.';
      }
      Get.snackbar("خطأ في المصادقة", message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      if (credential != null) {
        await credential.user?.delete();
      }
      Get.snackbar("خطأ فادح", "حدث خطأ غير متوقع: ${e.toString()}", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
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
      _actionCell(data),               // العمليات
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

  DataCell _actionCell(Map<String, dynamic> data) {
    return DataCell(
      SizedBox(
        width: 100, // عرض ثابت للأزرار
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.grey, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => print('View ${data['Column1']}'),
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
      final aVal = a[key]!.toLowerCase();
      final bVal = b[key]!.toLowerCase();
      return ascending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });

    filteredDataList.refresh();
  }

  // ======================= SEARCH =======================
  void searchQuery(String query) {
    List<Map<String, String>> baseList;

    if (selectedValue.value == 'all_types') {
      baseList = dataList;
    } else {
      baseList = dataList.where((item) {
        return item['Column4']?.toLowerCase() ==
            selectedValue.value;
      }).toList();
    }

    if (query.isEmpty) {
      filteredDataList.assignAll(baseList);
    } else {
      filteredDataList.assignAll(
        baseList.where(
              (item) => item.values.any(
                (v) => v.toLowerCase().contains(query.toLowerCase()),
          ),
        ),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (_) => false),
    );
  }


  // ======================= API =======================
  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('http://localhost/flymarket_php_api/dashboard/admin/user_management/view.php'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == 'success') {
          final List users = body['data'];

          dataList.assignAll(
            users.map<Map<String, String>>((user) {
              return {
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
  final options = ['all_types', 'admin', 'customer', 'driver', 'supermarket'];

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
      'value': 'customer',
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
