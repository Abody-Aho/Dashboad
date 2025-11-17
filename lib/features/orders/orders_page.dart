import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_dropdown_button.dart';
import '../widgets/custom_search_bar.dart';
import 'orders_controller.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    // بطاقات الإحصائيات
    List<Widget> statCards = [
      StatCard(
        title: 'إجمالي الطلبات',
        value: '2,540',
        percent: '7%',
        subtitle: 'مقارنة بالشهر الماضي',
      ),
      StatCard(
        title: 'الطلبات الجارية',
        value: '320',
        percent: '5%',
        subtitle: 'نسبة الزيادة هذا الأسبوع',
      ),
      StatCard(
        title: 'الطلبات المكتملة',
        value: '1,950',
        percent: '12%',
        subtitle: 'مقارنة بالشهر الماضي',
      ),
      StatCard(
        title: 'الطلبات الملغاة',
        value: '78',
        percent: '-4%',
        subtitle: 'نسبة الانخفاض هذا الأسبوع',
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
                  "إدارة الطلبات",
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("قائمة الطلبات",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("إدارة ومتابعة جميع الطلبات",style: TextStyle(color: Constants.grey,fontSize: 17)),
                      ),
                      const SizedBox(height: 20),
                      // الصف العلوي (زر + قائمة + بحث)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isPhone =
                              constraints.maxWidth <
                                  600;

                          if (isPhone) {
                            // عمودي - فوق بعض
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
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
                                CustomSearchBar(controller: controller, hintText: 'بحث',),
                              ],
                            );
                          } else {
                            // أفقي - بجانب بعض
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
                                    controller: controller, hintText: 'بحث',
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
