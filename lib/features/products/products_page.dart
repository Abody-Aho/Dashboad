import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/products/products_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/custom_bottom.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_dropdown_button.dart';
import '../widgets/custom_search_bar.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(ProductsController());

    // بطاقات الإحصائيات
    List<Widget> statCards = [
      StatCard(
        title: 'total_products'.tr,
        value: '1,245',
        percent: '8%',
        subtitle: 'compared_to_last_month'.tr,
      ),
      StatCard(
        title: 'active_products'.tr,
        value: '984',
        percent: '5%',
        subtitle: 'compared_to_last_month'.tr,
      ),
      StatCard(
        title: 'new_products'.tr,
        value: '124',
        percent: '12%',
        subtitle: 'compared_to_last_month'.tr,
      ),
      StatCard(
        title: 'unavailable_products'.tr,
        value: '15',
        percent: '-3%',
        subtitle: 'compared_to_last_month'.tr,
        percentColor: Colors.red,
        percentIcon: Icons.arrow_downward,
      ),
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
                  "manage_products".tr,
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // بطاقات الإحصائيات
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
                                CustomSearchBar(controller: controller, hintText: 'search'.tr,),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedCategories,
                                    options: controller.supermarketCategories,
                                    onChanged: controller.changeCategories,
                                  ),
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
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'add_product'.tr,
                                    onAddPressed: () {
                                      print("Add product pressed");
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
                                CustomBottom(
                                  controller: controller,
                                  addButtonText: 'add_product'.tr,
                                  onAddPressed: () {
                                    print("Add product pressed");
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 5.w,
                                  ),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedCategories,
                                    options: controller.supermarketCategories,
                                    onChanged: controller.changeCategories,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 5.w,
                                  ),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: controller.changeValue,
                                  ),
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

                      // جدول المستخدمين - مهم تحديد الارتفاع
                      SizedBox(
                        height: 500, // 👈 هذا يحل خطأ RenderBox
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
