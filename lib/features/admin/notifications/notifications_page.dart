import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/responsive_grid.dart';
import 'notifications_controller.dart';
import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationsController>();

    // بطاقات الإحصائيات
    List<Widget> statCards = [
      Obx(() => StatCard(
        title: 'total_notifications'.tr,
        value: controller.total.value.toString(),
        percent: '15%',
        subtitle: 'increase_last_week'.tr,
      )),

      Obx(() => StatCard(
        title: 'read_notifications'.tr,
        value: controller.read.value.toString(),
        percent: '10%',
        subtitle: 'improvement_engagement'.tr,
      )),

      Obx(() => StatCard(
        title: 'unread_notifications'.tr,
        value: controller.unread.value.toString(),
        percent: '5%',
        subtitle: 'awaiting_review'.tr,
      )),

      Obx(() => StatCard(
        title: 'deleted_notifications'.tr,
        value: controller.deleted.value.toString(),
        percent: '-6%',
        subtitle: 'decrease_deletion'.tr,
        percentColor: Colors.red,
        percentIcon: Icons.arrow_downward,
      )),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // العنوان
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "notifications_management".tr,
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // بطاقات الإحصائيات
              ResponsiveGrid(
                itemCount: statCards.length,
                itemBuilder: (context, index) => statCards[index],
              ),
              const SizedBox(height: 20),

              // جدول المستخدمين مع الخلفية المستديرة
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // الصف العلوي (زر + قائمة + بحث)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isPhone =
                              constraints.maxWidth < 600; // يمكن تعديل القيمة حسب الحاجة

                          if (isPhone) {
                            // عمودي - فوق بعض
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomSearchBar(controller: controller, hintText: 'search'.tr),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 11),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'create_notification'.tr,
                                    onAddPressed: () {
                                      controller.showCreateNotificationDialog();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 11),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'أضافة بنر'.tr,
                                    onAddPressed: () {
                                      controller.showAddBannerDialog();
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          } else {
                            // أفقي - بجانب بعض
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    CustomBottom(
                                      controller: controller,
                                      addButtonText: 'create_notification'.tr,
                                      onAddPressed: () {
                                        controller.showCreateNotificationDialog();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    CustomBottom(
                                      controller: controller,
                                      addButtonText: 'اضافة بنر'.tr,
                                      onAddPressed: () {
                                        controller.showAddBannerDialog();
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: CustomSearchBar(
                                    controller: controller, hintText: 'search'.tr,
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 500,
                        child: CustomDataTable(controller: controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
