import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import 'notifications_controller.dart';

mixin NotificationsDialogs on GetxController {
  NotificationsController get controller;

  void showAddBannerDialog() {
    controller.bannerImageBytes = null;
    controller.bannerImageName = null;

    update();
    controller.fetchBanners();
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
                color: Colors.black.withValues(alpha: .08),
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

                    Text(
                      "banner_manager".tr,
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

                const SizedBox(height: 20),

                /// CURRENT BANNERS
                Text(
                  "current_banners".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                controller.bannerSlider(),

                const SizedBox(height: 30),

                /// ADD BANNER
                Text(
                  "add_new_banner".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                          ? Center(child: Text("no_image_selected".tr))
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

                        onPressed: controller.pickBannerImage,

                        icon: const Icon(Icons.upload, color: Colors.white),

                        label: Text(
                          "choose_image".tr,
                          style: const TextStyle(color: Colors.white),
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

                          onPressed: controller.bannerLoading.value ? null : controller.uploadBanner,

                          child: controller.bannerLoading.value
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "upload".tr,
                            style: const TextStyle(color: Colors.white),
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

  void showCreateNotificationDialog() {
    controller.titleController.clear();
    controller.bodyController.clear();

    controller.selectedType.value = "general";
    controller.selectedReceivers.value = "users";

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
                    controller: controller.titleController,
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
                    controller: controller.bodyController,
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

                    switch (controller.selectedType.value) {
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
                      initialValue: controller.selectedType.value,

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
                          child: controller.typeBadge("general".tr, Colors.grey),
                        ),

                        DropdownMenuItem(
                          value: "offer",
                          child: controller.typeBadge("offer".tr, Colors.green),
                        ),

                        DropdownMenuItem(
                          value: "alert",
                          child: controller.typeBadge("alert".tr, Colors.red),
                        ),

                        DropdownMenuItem(
                          value: "update",
                          child: controller.typeBadge("update".tr, Colors.blue),
                        ),
                      ],

                      onChanged: (v) {
                        controller.selectedType.value = v.toString();
                      },
                    );
                  }),

                  const SizedBox(height: 15),

                  /// RECEIVERS
                  Obx(
                        () => DropdownButtonFormField(
                      initialValue: controller.selectedReceivers.value,

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

                      items: [
                        DropdownMenuItem(value: "users", child: Text("clients".tr)),

                        DropdownMenuItem(
                          value: "drivers",
                          child: Text("driver".tr),
                        ),

                        DropdownMenuItem(
                          value: "supermarkets",
                          child: Text("supermarkets".tr),
                        ),

                        DropdownMenuItem(value: "all", child: Text("all".tr)),
                      ],

                      onChanged: (v) {
                        controller.selectedReceivers.value = v.toString();
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

                            onPressed: controller.isLoading.value
                                ? null
                                : () async {
                              await controller.createNotification(
                                title: controller.titleController.text,
                                body: controller.bodyController.text,
                                type: controller.selectedType.value,
                                receivers: controller.selectedReceivers.value,
                              );
                            },

                            child: controller.isLoading.value
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                                : Text(
                              "send".tr,
                              style: const TextStyle(color: Colors.white),
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
                color: Colors.black.withValues(alpha: .08),
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
                          color: Colors.green.withValues(alpha: .1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        "notification_details".tr,
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
                  controller.detailItem("title".tr, data['Column1']),

                  const SizedBox(height: 15),

                  /// MESSAGE
                  controller.detailItem("message".tr, data['Column1']),

                  const SizedBox(height: 20),

                  /// TYPE
                  Row(
                    children: [
                      Text(
                        "${"type".tr} : ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 10),

                      controller.notificationTypeBadge(data['Column2'] ?? ""),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// RECEIVERS
                  controller.detailItem("receivers".tr, data['Column3']),

                  const SizedBox(height: 20),

                  /// STATS
                  Row(
                    children: [
                      Expanded(
                        child: controller.statCard(
                          "sent".tr,
                          data['Column4'],
                          Icons.send,
                          Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: controller.statCard(
                          "read".tr,
                          data['Column5'],
                          Icons.mark_email_read,
                          Colors.green,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: controller.statCard(
                          "rate".tr,
                          data['Column6'],
                          Icons.analytics,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// STATUS
                  controller.detailItem("status".tr, data['Column7']),

                  const SizedBox(height: 10),

                  /// DATE
                  controller.detailItem("date_text".tr, data['Column8']),

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

                      child: Text(
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
    );
  }

}
