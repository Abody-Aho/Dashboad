import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDeleteDialog {

  static void show({
    String title = "تأكيد الحذف",
    String message = "هل أنت متأكد من حذف هذا العنصر؟",
    String? itemName,
    IconData icon = Icons.warning_amber_rounded,
    Color color = Colors.red,
    required VoidCallback onConfirm,
    bool barrierDismissible = false,
  }) {

    Get.dialog(
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              minWidth: 300,
            ),

            child: Material(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          icon,
                          color: color,
                          size: 42,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        itemName != null
                            ? "$message\n$itemName"
                            : message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 25),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 250) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    onConfirm();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color,
                                  ),
                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("إلغاء"),
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("إلغاء"),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    onConfirm();
                                  },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color,
                                  ),

                                  child: const Text(
                                    "حذف",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );
  }
}