import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../data/models/notification_model.dart';
import '../../widgets/app_delete_dialog.dart';

class NotificationsController extends GetxController {
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

  /// خلايا الجدول
  List<DataCell> getDataCells(Map<String, String> data) {
    DataCell cell(String key, double width) {
      return DataCell(
        Tooltip(
          message: data[key] ?? '',
          child: SizedBox(
            width: width,
            child: Text(data[key] ?? '', overflow: TextOverflow.ellipsis),
          ),
        ),
      );
    }

    return [
      cell('Column1', 200),
      DataCell(_notificationTypeBadge(data['Column2'] ?? "")),
      cell('Column3', 140),
      cell('Column4', 100),
      cell('Column5', 100),
      cell('Column6', 100),
      cell('Column7', 100),
      cell('Column8', 150),

      DataCell(
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showNotificationDetails(data);
                  },
                  tooltip: "view".tr,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Future fetchBanners() async {
    try {
      var response = await http.get(Uri.parse(AppLink.bannerView));

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        banners.assignAll(data["data"]);
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
        showSuccess("Banner deleted");

        fetchBanners();
      }
    } catch (e) {
      print(e);
    }
  }

  Widget bannerSlider() {
    return Obx(() {
      if (banners.isEmpty) {
        return const Text("No banners");
      }

      return SizedBox(
        height: 160,

        child: PageView.builder(
          itemCount: banners.length,

          controller: PageController(viewportFraction: .9),

          onPageChanged: (index) {
            bannerIndex.value = index;
          },

          itemBuilder: (context, index) {
            var banner = banners[index];

            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),

                    image: DecorationImage(
                      fit: BoxFit.contain,

                      image: NetworkImage(
                        "${AppLink.imageBanner}${banner['banners_image']}",
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,

                  child: InkWell(
                    onTap: () {
                      AppDeleteDialog.show(
                        title: "حذف البانر",
                        message: "هل تريد حذف هذا البانر؟",
                        itemName: banner['banners_image'],
                        onConfirm: () {
                          deleteBanner(
                            banner['banners_id'].toString(),
                            banner['banners_image'],
                          );
                        },
                      );
                    },

                    child: Container(
                      padding: const EdgeInsets.all(6),

                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  /// أعمدة الجدول
  List<DataColumn> get tableColumns => [
    DataColumn(
      label: Text('title'.tr),
      onSort: (columnIndex, ascending) => sortData(0, ascending),
    ),

    DataColumn(
      label: Text('type'.tr),
      onSort: (columnIndex, ascending) => sortData(1, ascending),
    ),

    DataColumn(
      label: Text('receivers'.tr),
      onSort: (columnIndex, ascending) => sortData(2, ascending),
    ),

    DataColumn(
      label: Text('sent_count'.tr),
      onSort: (columnIndex, ascending) => sortData(3, ascending),
    ),

    DataColumn(
      label: Text('read_count'.tr),
      onSort: (columnIndex, ascending) => sortData(4, ascending),
    ),

    DataColumn(
      label: Text('read_rate'.tr),
      onSort: (columnIndex, ascending) => sortData(5, ascending),
    ),

    DataColumn(
      label: Text('status'.tr),
      onSort: (columnIndex, ascending) => sortData(6, ascending),
    ),

    DataColumn(
      label: Text('send_date'.tr),
      onSort: (columnIndex, ascending) => sortData(7, ascending),
    ),

    DataColumn(label: Text('actions'.tr)),
  ];

  /// الفرز
  void sortData(int columnIndex, bool ascending) {
    sortColumnIndex.value = columnIndex;
    sortAscending.value = ascending;

    String columnKey = 'Column${columnIndex + 1}';

    filteredDataList.sort((a, b) {
      final valueA = (a[columnKey] ?? '').toLowerCase();
      final valueB = (b[columnKey] ?? '').toLowerCase();

      return ascending ? valueA.compareTo(valueB) : valueB.compareTo(valueA);
    });

    filteredDataList.refresh();
  }

  /// البحث
  void searchQuery(String query) {
    if (query.isEmpty) {
      filteredDataList.assignAll(dataList);
    } else {
      filteredDataList.assignAll(
        dataList.where((item) {
          return item.values.any(
            (value) => value.toLowerCase().contains(query.toLowerCase()),
          );
        }).toList(),
      );
    }

    selectedRows.assignAll(
      List.generate(filteredDataList.length, (index) => false),
    );
  }

  Future pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      bannerImageBytes = result.files.first.bytes;
      bannerImageName = result.files.first.name;

      update();
    }
  }

  void showAddBannerDialog() {
    bannerImageBytes = null;
    bannerImageName = null;

    update();
    fetchBanners();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,

        child: Container(
          width: Get.width < 600 ? Get.width * .95 : 600,

          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// HEADER
                Row(
                  children: [
                    const Icon(Icons.image, color: Colors.green),

                    const SizedBox(width: 10),

                    const Text(
                      "Banner Manager",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// CURRENT BANNERS
                const Text(
                  "Current Banners",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                bannerSlider(),

                const SizedBox(height: 30),

                /// ADD BANNER
                const Text(
                  "Add New Banner",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                GetBuilder<NotificationsController>(
                  builder: (controller) {
                    return Container(
                      height: 160,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(.4)),
                      ),

                      child: controller.bannerImageBytes == null
                          ? const Center(child: Text("No image selected"))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.memory(
                                controller.bannerImageBytes!,
                                fit: BoxFit.contain,
                              ),
                            ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),

                        onPressed: pickBannerImage,

                        icon: const Icon(Icons.upload, color: Colors.white),

                        label: const Text(
                          "Choose Image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Obx(
                      () => Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),

                          onPressed: bannerLoading.value ? null : uploadBanner,

                          child: bannerLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Upload",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future uploadBanner() async {

    if (bannerImageBytes == null) {
      showError("Please choose image");
      return;
    }

    try {

      bannerLoading.value = true;

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(AppLink.bannerAdd),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          bannerImageBytes!,
          filename: bannerImageName,
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {

        bannerImageBytes = null;
        bannerImageName = null;

        fetchBanners();
        update();

        showSuccess("Banner uploaded successfully");

      } else {

        showError("Upload failed");

      }

    } catch (e) {

      showError("Server connection failed");

    } finally {

      bannerLoading.value = false;

    }
  }

  void showCreateNotificationDialog() {
    titleController.clear();
    bodyController.clear();

    selectedType.value = "general";
    selectedReceivers.value = "users";

    Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,

        child: Container(
          width: 470,

          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(22),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .08),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 600),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        "create_notification".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// TITLE
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "title".tr,

                      labelStyle: const TextStyle(color: Constants.text),
                      floatingLabelStyle: const TextStyle(
                        color: Constants.text,
                      ),

                      prefixIcon: const Icon(Icons.title),

                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// BODY
                  TextField(
                    controller: bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "message".tr,

                      labelStyle: const TextStyle(color: Constants.text),
                      floatingLabelStyle: const TextStyle(
                        color: Constants.text,
                      ),

                      prefixIcon: const Icon(Icons.message),

                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// TYPE
                  Obx(() {
                    Color color;

                    switch (selectedType.value) {
                      case "offer":
                        color = Colors.green;
                        break;

                      case "alert":
                        color = Colors.red;
                        break;

                      case "update":
                        color = Colors.blue;
                        break;

                      default:
                        color = Colors.grey;
                    }

                    return DropdownButtonFormField(
                      initialValue: selectedType.value,

                      decoration: InputDecoration(
                        labelText: "type".tr,

                        labelStyle: const TextStyle(color: Constants.text),
                        floatingLabelStyle: const TextStyle(
                          color: Constants.text,
                        ),

                        prefixIcon: Icon(Icons.category, color: color),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      items: [
                        DropdownMenuItem(
                          value: "general",
                          child: _typeBadge("general", Colors.grey),
                        ),

                        DropdownMenuItem(
                          value: "offer",
                          child: _typeBadge("offer", Colors.green),
                        ),

                        DropdownMenuItem(
                          value: "alert",
                          child: _typeBadge("alert", Colors.red),
                        ),

                        DropdownMenuItem(
                          value: "update",
                          child: _typeBadge("update", Colors.blue),
                        ),
                      ],

                      onChanged: (v) {
                        selectedType.value = v.toString();
                      },
                    );
                  }),

                  const SizedBox(height: 15),

                  /// RECEIVERS
                  Obx(
                    () => DropdownButtonFormField(
                      initialValue: selectedReceivers.value,

                      decoration: InputDecoration(
                        labelText: "receivers".tr,

                        labelStyle: const TextStyle(color: Constants.text),
                        floatingLabelStyle: const TextStyle(
                          color: Constants.text,
                        ),

                        prefixIcon: const Icon(Icons.groups),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(value: "users", child: Text("Users")),

                        DropdownMenuItem(
                          value: "drivers",
                          child: Text("Drivers"),
                        ),

                        DropdownMenuItem(
                          value: "supermarkets",
                          child: Text("Supermarkets"),
                        ),

                        DropdownMenuItem(value: "all", child: Text("All")),
                      ],

                      onChanged: (v) {
                        selectedReceivers.value = v.toString();
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          onPressed: () {
                            Get.back();
                          },

                          child: Text("cancel".tr),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Obx(
                        () => Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),

                            onPressed: isLoading.value
                                ? null
                                : () async {
                                    await createNotification(
                                      title: titleController.text,
                                      body: bodyController.text,
                                      type: selectedType.value,
                                      receivers: selectedReceivers.value,
                                    );
                                  },

                            child: isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Send",
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  void showSuccess(String message) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.green,
      borderRadius: 10,
      margin: const EdgeInsets.all(15),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void showError(String message) {
    Get.rawSnackbar(
      messageText: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),

      backgroundColor: Colors.red,
      borderRadius: 10,
      margin: const EdgeInsets.all(15),
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  Widget _notificationTypeBadge(String type) {
    Color color;

    switch (type) {
      case "offer":
        color = Colors.green;
        break;

      case "alert":
        color = Colors.red;
        break;

      case "update":
        color = Colors.blue;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        type,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Future createNotification({
    required String title,
    required String body,
    required String type,
    required String receivers,
  }) async {
    if (title.isEmpty || body.isEmpty) {
      showError("Please enter title and message");

      return;
    }

    try {
      isLoading.value = true;

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

        showSuccess("Notification sent successfully");

        fetchNotifications();
      } else {
        showError("Something went wrong");
      }
    } catch (e) {
      showError("Server connection failed");
    } finally {
      isLoading.value = false;
    }
  }

  void showNotificationDetails(Map<String, String> data) {
    Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,

        child: Container(
          width: 500,

          padding: const EdgeInsets.all(25),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: Get.height * 0.8),

            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Text(
                        "Notification Details",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// TITLE
                  _detailItem("Title", data['Column1']),

                  const SizedBox(height: 15),

                  /// MESSAGE
                  _detailItem("Message", data['Column1']),

                  const SizedBox(height: 20),

                  /// TYPE
                  Row(
                    children: [
                      const Text(
                        "Type : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 10),

                      _notificationTypeBadge(data['Column2'] ?? ""),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// RECEIVERS
                  _detailItem("Receivers", data['Column3']),

                  const SizedBox(height: 20),

                  /// STATS
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          "Sent",
                          data['Column4'],
                          Icons.send,
                          Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statCard(
                          "Read",
                          data['Column5'],
                          Icons.mark_email_read,
                          Colors.green,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _statCard(
                          "Rate",
                          data['Column6'],
                          Icons.analytics,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// STATUS
                  _detailItem("Status", data['Column7']),

                  const SizedBox(height: 10),

                  /// DATE
                  _detailItem("Date", data['Column8']),

                  const SizedBox(height: 25),

                  /// CLOSE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      onPressed: () {
                        Get.back();
                      },

                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailItem(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 5),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(value ?? "-"),
        ),
      ],
    );
  }

  Widget _statCard(String title, String? value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 5),

          Text(
            value ?? "-",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),

          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // جلب الإشعارات
  Future fetchNotifications() async {
    try {
      isLoading.value = true;

      var response = await http.get(Uri.parse(AppLink.notificationsView));

      var data = jsonDecode(response.body);

      if (data["status"] == "success") {
        List list = data["data"];

        dataList.assignAll(
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

        filteredDataList.assignAll(dataList);

        selectedRows.assignAll(
          List.generate(filteredDataList.length, (index) => false),
        );
      }
    } catch (e) {
      print("Notification Error: $e");
    } finally {
      isLoading.value = false;
    }
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
