import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'orders_supermarket_controller.dart';

mixin OrderSupermarketDialogs on GetxController {
  OrdersSupermarketController get controller;

  void showStatusDialog(
    int orderId,
    int currentStatus,
    OrdersSupermarketController controller,
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
                                "cancel_text".tr,
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
    Get.dialog(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),

          child: Material(
            borderRadius: BorderRadius.circular(16),

            child: Padding(
              padding: const EdgeInsets.all(24),

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
                        controller.infoRow("driver_text".tr, order['Column4']),
                        controller.infoRow("payment_text".tr, order['Column6']),
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

                            DataCell(Text((item['quantity'] ?? 0).toString())),

                            DataCell(
                              Text(
                                (item['item_price_after_discount'] ?? 0)
                                    .toString(),
                              ),
                            ),

                            DataCell(
                              Text((item['total_items_price'] ?? 0).toString()),
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

      barrierDismissible: true,
    );
  }
}
