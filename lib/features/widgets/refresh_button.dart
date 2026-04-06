import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RefreshButton extends StatelessWidget {
  final RxBool isLoading;
  final Future<void> Function() onRefresh;

  const RefreshButton({
    super.key,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
      onPressed: isLoading.value
          ? null
          : () async {
        isLoading.value = true;

        await onRefresh();

        isLoading.value = false;

        Get.snackbar(
          "تم التحديث",
          "تم تحديث البيانات بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      },
      icon: isLoading.value
          ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.green,
        ),
      )
          : AnimatedRotation(
        turns: isLoading.value ? 1 : 0,
        duration: const Duration(milliseconds: 800),
        child: const Icon(Icons.replay, color: Colors.green),
      ),
    ));
  }
}