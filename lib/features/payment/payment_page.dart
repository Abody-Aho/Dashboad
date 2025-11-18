import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/payment/payment_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_dropdown_button.dart';
import '../widgets/custom_search_bar.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());

    // بطاقات الإحصائيات
    List<Widget> statCards = [
      StatCard(
        title: 'total_payments'.tr,
        value: '4,560,000 ر.ي',
        percent: '12%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'completed_payments'.tr,
        value: '3,980',
        percent: '7%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'pending_payments'.tr,
        value: '215',
        percent: '3%',
        subtitle: 'awaiting_confirmation'.tr,
      ),
      StatCard(
        title: 'failed_payments'.tr,
        value: '45',
        percent: '-4%',
        subtitle: 'compared_last_month'.tr,
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
                  "payment_management".tr,
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
                                CustomSearchBar(controller: controller, hintText: 'search'.tr),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedWay,
                                    options: controller.paymentWay,
                                    onChanged: controller.changeWay,
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
                              ],
                            );
                          } else {
                            // أفقي - بجانب بعض
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedWay,
                                    options: controller.paymentWay,
                                    onChanged: controller.changeWay,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: controller.changeValue,
                                  ),
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
