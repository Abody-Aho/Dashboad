import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_link.dart';
import '../../widgets/app_delete_dialog.dart';
import 'notifications_controller.dart';

mixin NotificationsHelpers on GetxController {
  NotificationsController get controller;

  Widget bannerSlider() {
    return Obx(() {
      if (controller.banners.isEmpty) {
        return Text("no_banners".tr);
      }

      return SizedBox(
        height: 160,

        child: PageView.builder(
          itemCount: controller.banners.length,

          controller: PageController(viewportFraction: .9),

          onPageChanged: (index) {
            controller.bannerIndex.value = index;
          },

          itemBuilder: (context, index) {
            var banner = controller.banners[index];

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
                        title: "delete_banner".tr,
                        message: "confirm_delete_banner".tr,
                        itemName: banner['banners_image'],
                        onConfirm: () {
                          controller.deleteBanner(
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

  Future pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      controller.bannerImageBytes = result.files.first.bytes;
      controller.bannerImageName = result.files.first.name;

      update();
    }
  }

  Widget typeBadge(String text, Color color) {
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

  Widget notificationTypeBadge(String type) {
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
        type.tr,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget detailItem(String title, String? value) {
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

  Widget statCard(String title, String? value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
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

}
