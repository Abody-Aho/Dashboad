import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import 'orders_controller.dart';

mixin OrderDialogs on GetxController {
  OrdersController get controller;

  void showStatusDialog(
    int orderId,
    int currentStatus,
    OrdersController controller,
  ) {
    int selectedStatus = currentStatus;

    final statuses = [
      {
        "id": 0,
        "title": "pending".tr,
        "color": Colors.orange,
        "icon": Icons.schedule,
      },
      {
        "id": 1,
        "title": "accepted".tr,
        "color": Colors.blue,
        "icon": Icons.check_circle,
      },
      {"id": 2, "title": "ready".tr, "color": Colors.teal, "icon": Icons.store},
      {
        "id": 3,
        "title": "on_delivery".tr,
        "color": Colors.deepPurple,
        "icon": Icons.delivery_dining,
      },
      {
        "id": 4,
        "title": "delivered".tr,
        "color": Colors.green,
        "icon": Icons.task_alt,
      },
      {
        "id": 5,
        "title": "cancelled".tr,
        "color": Colors.red,
        "icon": Icons.cancel,
      },
    ];

    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),

          child: Material(
            borderRadius: BorderRadius.circular(16),

            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "change_order_status".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: statuses.map((status) {
                          bool isSelected = selectedStatus == status["id"];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStatus = status["id"] as int;
                              });
                            },

                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),

                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 10,
                              ),

                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (status["color"] as Color).withValues(
                                        alpha: .15,
                                      )
                                    : Colors.grey.withValues(alpha: .08),

                                borderRadius: BorderRadius.circular(12),

                                border: Border.all(
                                  color: isSelected
                                      ? status["color"] as Color
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),

                              child: Column(
                                children: [
                                  Icon(
                                    status["icon"] as IconData,
                                    color: status["color"] as Color,
                                    size: 28,
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    status["title"] as String,
                                    style: TextStyle(
                                      color: status["color"] as Color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                "cancel".tr,
                                style: const TextStyle(color: Constants.text),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),

                              onPressed: () {
                                controller.updateOrderStatus(
                                  orderId,
                                  selectedStatus,
                                );

                                Get.back();
                              },

                              child: Text(
                                "update_status".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),

      barrierDismissible: false,
    );
  }

  void showOrderDetailsDialog({required Map order, required List items}) {
    String? image;

    // نجيب الصورة من أول عنصر
    if (items.isNotEmpty && items[0]['orders_image_pay'] != null) {
      image = items[0]['orders_image_pay'];
    }

    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.receipt_long,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${"order_details".tr} #${order['id']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ORDER INFO
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          controller.infoRow("client".tr, order['Column2']),
                          controller.infoRow(
                            "supermarket_text".tr,
                            order['Column3'],
                          ),
                          controller.infoRow(
                            "driver_text".tr,
                            order['Column4'],
                          ),
                          controller.infoRow(
                            "payment_text".tr,
                            order['Column6'],
                          ),
                          controller.infoRow("date_text".tr, order['Column8']),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ITEMS TABLE
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text("product".tr)),
                          DataColumn(label: Text("quantity".tr)),
                          DataColumn(label: Text("price_text".tr)),
                          DataColumn(label: Text("total".tr)),
                        ],
                        rows: items.map<DataRow>((item) {
                          return DataRow(
                            cells: [
                              DataCell(Text(item['item_name_ar'] ?? '-')),
                              DataCell(
                                Text((item['quantity'] ?? 0).toString()),
                              ),
                              DataCell(
                                Text(
                                  (item['item_price_after_discount'] ?? 0)
                                      .toString(),
                                ),
                              ),
                              DataCell(
                                Text(
                                  (item['total_items_price'] ?? 0).toString(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// TOTAL
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "total_amount".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${order['Column5']} ${"currency_yr".tr}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 PAYMENT IMAGE SECTION
                    if (image != null && image.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "payment_image".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              "${AppLink.imageOrders}$image",
                              height: 500,
                              width: double.infinity,
                              fit: BoxFit.contain,

                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 120,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "image_load_failed".tr,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              },

                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return SizedBox(
                                  height: 120,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: progress.expectedTotalBytes != null
                                          ? progress.cumulativeBytesLoaded /
                                                (progress.expectedTotalBytes ??
                                                    1)
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "cash_payment".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    /// CLOSE BUTTON
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () => Get.back(),
                        label: Text(
                          "close".tr,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void showCouponDialog() {
    controller.fetchCoupons();

    final name = TextEditingController();
    final count = TextEditingController();
    final discount = TextEditingController();
    final expire = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.9),
          width: Get.width < 600 ? Get.width * 0.95 : Get.width * 0.6,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "coupon_management".tr,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                /// ================= FORM =================
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    controller.input(name, "coupon_name".tr),
                    controller.input(count, "usage_count".tr),
                    controller.input(discount, "discount".tr),

                    /// DatePicker
                    SizedBox(
                      width: 220,
                      child: TextField(
                        controller: expire,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "expire_date".tr,
                          filled: true,
                          fillColor: Colors.green.shade50,
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: Get.context!,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                          );

                          if (picked != null) {
                            expire.text =
                                "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')} 00:00:00";
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// ================= ADD =================
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      if (name.text.isEmpty ||
                          count.text.isEmpty ||
                          discount.text.isEmpty ||
                          expire.text.isEmpty) {
                        Get.snackbar("warning".tr, "all_fields_required".tr);
                        return;
                      }

                      controller.addCoupon({
                        "name": name.text.trim(),
                        "count": count.text.trim(),
                        "discount": discount.text.trim(),
                        "expire": expire.text.trim(),
                      });

                      name.clear();
                      count.clear();
                      discount.clear();
                      expire.clear();
                    },
                    child: Text(
                      "add".tr,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                const Divider(),

                /// ================= LIST =================
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }

                  if (controller.couponsList.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "no_coupons".tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: controller.couponsList.length,
                      itemBuilder: (c, i) {
                        final item = controller.couponsList[i] ?? {};

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(
                              item['Column1'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "discount_text".trParams({
                                'discount': item['Column2'] ?? '0',
                                'count': item['Column3'] ?? '0',
                              }),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    showEditCouponDialog(item);
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Get.dialog(
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        title: Text("delete_coupon".tr),
                                        content: Text(
                                          "confirm_delete_coupon".trParams({
                                            'name': item['Column1'] ?? '',
                                          }),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: Text("cancel".tr),
                                          ),

                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              controller.deleteCoupon(
                                                int.parse(item['id']),
                                              );
                                              Get.back();
                                            },
                                            child: Text("delete_text".tr),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showEditCouponDialog(Map item) {
    final name = TextEditingController(text: item['Column1'] ?? '');
    final count = TextEditingController(text: item['Column3'] ?? '');
    final discount = TextEditingController(text: item['Column2'] ?? '');
    final expire = TextEditingController(text: item['Column4'] ?? '');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Container(
          width: Get.width < 600 ? Get.width * 0.95 : Get.width * 0.5,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔥 العنوان
                Text(
                  "edit_coupon".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 20),

                /// الاسم
                controller.input(name, "coupon_name".tr),
                const SizedBox(height: 12),

                /// العدد
                controller.input(count, "usage_count".tr),
                const SizedBox(height: 12),

                /// الخصم
                controller.input(discount, "discount".tr),
                const SizedBox(height: 12),

                /// DatePicker
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: expire,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "expire_date".tr,
                      filled: true,
                      fillColor: Colors.green.shade50,
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () async {
                      DateTime initialDate = DateTime.now();

                      try {
                        if (expire.text.isNotEmpty) {
                          initialDate = DateTime.parse(expire.text);
                        }
                      } catch (_) {}

                      DateTime? picked = await showDatePicker(
                        context: Get.context!,
                        initialDate: initialDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2035),
                      );

                      if (picked != null) {
                        expire.text =
                            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')} 00:00:00";
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 الأزرار
                Row(
                  children: [
                    /// إلغاء
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text("cancel".tr),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// حفظ
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {
                          if (name.text.isEmpty ||
                              count.text.isEmpty ||
                              discount.text.isEmpty ||
                              expire.text.isEmpty) {
                            Get.snackbar(
                              "warning".tr,
                              "all_fields_required".tr,
                            );
                            return;
                          }

                          controller.editCoupon(int.parse(item['id']), {
                            "name": name.text.trim(),
                            "count": count.text.trim(),
                            "discount": discount.text.trim(),
                            "expire": expire.text.trim(),
                          });

                          Get.back();
                        },
                        child: Text(
                          "save".tr,
                          style: const TextStyle(color: Colors.white),
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
}
