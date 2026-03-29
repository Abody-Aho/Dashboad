import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/responsive_grid.dart';
import 'orders_supermarket_controller.dart';

class OrdersSupermarketPage extends StatelessWidget {
  const OrdersSupermarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersSupermarketController>();

    // بطاقات الإحصائيات
    List<Widget> statCards = [
      Obx(() => StatCard(
        title: 'total_orders'.tr,
        value: controller.totalOrders.value.toString(),
        percent: '7%',
        subtitle: 'compared_last_month'.tr,
      )),

      Obx(() => StatCard(
        title: 'running_orders'.tr,
        value: controller.runningOrders.value.toString(),
        percent: '5%',
        subtitle: 'increase_this_week'.tr,
      )),

      Obx(() => StatCard(
        title: 'completed_orders'.tr,
        value: controller.completedOrders.value.toString(),
        percent: '12%',
        subtitle: 'compared_last_month'.tr,
      )),

      Obx(() => StatCard(
        title: 'cancelled_orders'.tr,
        value: controller.cancelledOrders.value.toString(),
        percent: '-4%',
        subtitle: 'decrease_this_week'.tr,
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
                  "orders_management".tr,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topRight,
                        child: Text(
                          "orders_list".tr,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topRight,
                        child: Text(
                          "orders_management_description".tr,
                          style:
                          TextStyle(color: Constants.grey, fontSize: 17),
                        ),
                      ),

                      const SizedBox(height: 20),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isPhone = constraints.maxWidth < 600;

                          if (isPhone) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                CustomSearchBar(
                                  controller: controller,
                                  hintText: 'search'.tr,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: controller.changeValue,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDropdownButton(
                                  selectedValue: controller.selectedValue,
                                  options: controller.options,
                                  onChanged: controller.changeValue,
                                ),
                                Expanded(
                                  child: CustomSearchBar(
                                    controller: controller,
                                    hintText: 'search'.tr,
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
