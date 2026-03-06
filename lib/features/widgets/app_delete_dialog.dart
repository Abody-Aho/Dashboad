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
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            minWidth: 300,
          ),

          child: Material(
            borderRadius: BorderRadius.circular(16),

            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// ICON
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

                  /// TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// MESSAGE
                  Text(
                    itemName != null
                        ? "$message\n$itemName"
                        : message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  /// BUTTONS
                  Row(
                    children: [

                      /// CANCEL
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text("إلغاء"),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// DELETE
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      barrierDismissible: barrierDismissible,
    );
  }
}