import 'dart:convert';
import 'package:dashbord2/core/constants/app_link.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/services/api_service.dart';
import '../../../data/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';



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
  final vehicleController = TextEditingController();


  //  حالات الواجهة

  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  Uint8List? imageBytes;
  String? imageName;



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
        location: "غير محدد",
        timeOpen: "6am to 6pm",
      );

      if (response['status'] == 'success') {
        Get.back(); // إغلاق النافذة
        await fetchUsers(); // تحديث الجدول
        Get.snackbar("تم", "تمت إضافة $role بنجاح", backgroundColor: Colors.green, colorText: Colors.white);
        _clearInputs(); // دالة لتنظيف الحقول
      } else {
        if (uid != null) await _auth.currentUser?.delete();
        Get.snackbar("خطأ", response['message']);
        print(response['message']);
      }

    } catch (e) {
      Get.snackbar("خطأ", e.toString(),backgroundColor: Colors.red, colorText: Colors.white);
      print(e.toString());

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

  void showEditDialog(UserModel user) {
    fillControllers(user);

    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [


                    const Text(
                      "تعديل المستخدم",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// صورة
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: imageBytes != null
                            ? MemoryImage(imageBytes!)
                            : user.image != null
                            ? NetworkImage(
                          "http://46.101.225.45/flymarket/dashboard/admin/upload/${user.image}",
                        )
                            : null,
                        child: imageBytes == null && user.image == null
                            ? const Icon(Icons.camera_alt)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// ====== حقول خاصة بالسوبرماركت ======
                    if (user.role == "supermarket") ...[
                      TextField(
                        controller: nameArController,
                        decoration: const InputDecoration(
                          labelText: "الاسم بالعربي",
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          labelText: "الموقع",
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: timeOpenController,
                        decoration: const InputDecoration(
                          labelText: "وقت العمل",
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],

                    /// ====== الحقول الأساسية ======
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "الاسم"),
                    ),
                    const SizedBox(height: 15),

                    if (user.role == "admin" || user.role == "supermarket")
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "البريد"),
                      ),

                    if (user.role == "admin" || user.role == "supermarket")
                      const SizedBox(height: 15),

                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: "الهاتف"),
                    ),

                    const SizedBox(height: 15),

                    /// ====== حقل خاص بالمندوب ======
                    if (user.role == "driver") ...[
                      TextField(
                        controller: vehicleController,
                        decoration: const InputDecoration(
                          labelText: "رقم المركبة",
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () => updateUser(user),
                      child: const Text(
                        "حفظ التعديلات",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )

              ),
            ),
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
                onPressed: () {
                  final user = UserModel(
                    id: int.tryParse(data['id'] ?? ''),
                    firebaseUid: '', // غير مستخدم في التعديل
                    name: data['Column1'] ?? '',
                    email: data['Column2'] ?? '',
                    phone: data['Column3'] ?? '',
                    role: data['role_raw'] ?? '',
                    status: data['Column5'] == 'active'.tr ? 1 : 0,
                  );

                  showEditDialog(user);
                },
                tooltip: 'Edit'.tr,
              ),
            ),
            Flexible(
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 25),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Get.dialog(
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 500,   // أقصى عرض ثابت
                          minWidth: 300,   // أقل عرض
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                // أيقونة
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                    size: 42,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Text(
                                  "تأكيد الحذف",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  "هل أنت متأكد من حذف هذا المستخدم؟\nلا يمكن التراجع عن هذه العملية.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Get.back(),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("إلغاء"),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.back();
                                          deleteUserFromServer(
                                            id: data['id'],
                                            role: data['role_raw'],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "حذف",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    barrierDismissible: false,
                  );

                },
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
    final role = user["role_raw"];
    final isActive = user["Column5"] == "active".tr;

    final newStatus = isActive ? "0" : "1";

    try {
      final response = await http.post(
        Uri.parse(
            AppLink.status),
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

  Future<void> deleteUserFromServer({
    required String id,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(
            AppLink.delete),
        body: {
          "id": id,
          "role": role,
        },
      );

      final body = jsonDecode(response.body);

      if (body["status"] == "success") {
        Get.snackbar(
          "تم",
          "تم حذف المستخدم بنجاح",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await fetchUsers(); // تحديث الجدول
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



  // ======================= حذف و تنشيط جماعي =======================
  List<Map<String, dynamic>> getSelectedUsers() {
    List<Map<String, dynamic>> selectedUsers = [];

    for (int i = 0; i < selectedRows.length; i++) {
      if (selectedRows[i]) {
        selectedUsers.add(filteredDataList[i]);
      }
    }

    return selectedUsers;
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
        await deleteUserFromServer(
          id: user['id'],
          role: user['role_raw'],
        );
      }

      selectedRows.assignAll(
        List.generate(filteredDataList.length, (_) => false),
      );

      await fetchUsers();

      Get.snackbar("تم", "تم حذف المستخدمين المحددين");
    } catch (e) {
      Get.snackbar("خطأ", "فشل الحذف الجماعي");
    } finally {
      isLoading.value = false;
    }
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
          body: {
            "id": user['id'],
            "status": status,
            "role": user['role'],
          },
        );
      }

      await fetchUsers();

      Get.snackbar("تم", "تم تحديث حالة المستخدمين");
    } catch (e) {
      Get.snackbar("خطأ", "فشل التحديث الجماعي");
    } finally {
      isLoading.value = false;
    }
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
          "${AppLink.searchUsers}?query=${Uri.encodeComponent(query)}",
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


  // ======================= Update =======================
  void fillControllers(UserModel user) {
    nameController.text = user.name;
    nameArController.text = user.nameAr ?? '';
    emailController.text = user.email;
    phoneController.text = user.phone;
    locationController.text = user.location ?? '';
    timeOpenController.text = user.timeOpen ?? '';
    vehicleController.text = user.vehicleNumber ?? '';
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      imageBytes = result.files.first.bytes;
      imageName = result.files.first.name;
    }
  }

  Future<void> updateUser(UserModel user) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        "http://46.101.225.45/flymarket/dashboard/admin/user_management/update_account.php",
      ),
    );

    final updatedUser = UserModel(
      id: user.id,
      firebaseUid: user.firebaseUid,
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      role: user.role,
      status: user.status,
      nameAr: nameArController.text,
      location: locationController.text,
      timeOpen: timeOpenController.text,
      vehicleNumber: vehicleController.text,
    );

    request.fields.addAll(updatedUser.toFields());

    if (imageBytes != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes!,
          filename: imageName,
        ),
      );
    }




    var response = await request.send();
    var body = await response.stream.bytesToString();

    print(body);

    Get.back(); // إغلاق الدايلوق
    await fetchUsers(); // تحديث الجدول
  }


  // ======================= DATE FORMAT =======================
  String _formatDate(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty) return '-';
    return dateTime.split(' ').first;
  }

  // ======================= FILTER =======================
  final selectedValue = 'all_types'.obs;
  final options = ['all_types', 'admin', 'users', 'driver', 'supermarket'];

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
