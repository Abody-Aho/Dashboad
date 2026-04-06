import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/supermarket/products/products_supermarket_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/category_dropdown.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/refresh_button.dart';
import '../../widgets/responsive_grid.dart';
class ProductsSupermarketPage extends StatelessWidget {
  const ProductsSupermarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductsSupermarketController>();


    // بطاقات الإحصائيات
    List<Widget> statCards = [
      Obx(() => StatCard(
        title: 'total_products'.tr,
        value: controller.totalProducts.value.toString(),
        percent: '8%',
        subtitle: 'compared_to_last_month'.tr,
      )),

      Obx(() => StatCard(
        title: 'active_products'.tr,
        value: controller.activeProducts.value.toString(),
        percent: '5%',
        subtitle: 'compared_to_last_month'.tr,
      )),

      Obx(() => StatCard(
        title: 'new_products'.tr,
        value: controller.newProducts.value.toString(),
        percent: '12%',
        subtitle: 'compared_to_last_month'.tr,
      )),

      Obx(() => StatCard(
        title: 'unavailable_products'.tr,
        value: controller.unavailableProducts.value.toString(),
        percent: '-3%',
        subtitle: 'compared_to_last_month'.tr,
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
                                RefreshButton(
                                  isLoading: controller.isLoading,
                                  onRefresh: () async {
                                    await controller.fetchProducts();
                                  },
                                ),
                                CustomSearchBar(controller: controller, hintText: 'search'.tr,),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CategoryDropdown(
                                    categories: controller.categoriesAll,
                                    selectedCategory: controller.selectedCategory,
                                    onChanged: (value) {
                                      controller.filterByCategory(value);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomDropdownButton<String>(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: (value) {
                                      controller.filterByStatus(value);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'add_product'.tr,
                                    onAddPressed: () {
                                      controller.resetDialogState();
                                      controller.showAddProductDialog();
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
                                RefreshButton(
                                  isLoading: controller.isLoading,
                                  onRefresh: () async {
                                    await controller.fetchProducts();
                                  },
                                ),
                                CustomBottom(
                                  controller: controller,
                                  addButtonText: 'add_product'.tr,
                                  onAddPressed: () {
                                    controller.resetDialogState();
                                    controller.showAddProductDialog();
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CategoryDropdown(
                                    categories: controller.categoriesAll,
                                    selectedCategory: controller.selectedCategory,
                                    onChanged: (value) {
                                      controller.filterByCategory(value);
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CustomDropdownButton<String>(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: (value) {
                                      controller.filterByStatus(value);
                                    },
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

                      // جدول المنتجات
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
