import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_data_table.dart';
import '../widgets/custom_search_bar.dart';
import 'mangmant_supermarket_controller.dart';

class ManagementSupermarketPage extends StatelessWidget {
  const ManagementSupermarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ManagementSupermarketController controller = Get.put(
      ManagementSupermarketController(),
    );

    final List<Widget> statCards = [
      StatCard(
        title: 'total_supermarkets'.tr,
        value: '120',
        percent: '6%',
        subtitle: 'compare_last_month'.tr,
      ),
      StatCard(
        title: 'active_supermarkets'.tr,
        value: '98',
        percent: '4%',
        subtitle: 'compare_last_month'.tr,
      ),
      StatCard(
        title: 'new_orders'.tr,
        value: '245',
        percent: '10%',
        subtitle: 'compare_last_month'.tr,
      ),
      StatCard(
        title: 'rejected_supermarkets'.tr,
        value: '7',
        percent: '-2%',
        subtitle: 'compare_last_month'.tr,
        percentColor: Colors.red,
        percentIcon: Icons.arrow_downward,
      ),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // العنوان
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "supermarket_management".tr,
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth > 500) {
                    crossAxisCount = 2;
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.0,
                    children: statCards,
                  );
                },
              ),

              const SizedBox(height: 20),

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
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "supermarket_list".tr,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "manage_requests_and_data".tr,
                          style: TextStyle(
                            color: Constants.grey,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // الصف العلوي (بحث)
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
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
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

                      // جدول الطلابات
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
