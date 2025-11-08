import 'package:dashbord2/features/widgets/custom_data_table2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../drawer/sidebar_controller.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_data_table.dart';
import 'mangmant_supermarket_controller.dart';

class MangmantSupermarketPage extends StatelessWidget {
  const MangmantSupermarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final MangmantSupermarketController controller = Get.put(MangmantSupermarketController());

    final List<Widget> statCards = const [
      StatCard(
        title: 'إجمالي المتاجر',
        value: '120',
        percent: '6%',
        subtitle: 'مقارنة بالشهر الماضي',
      ),
      StatCard(
        title: 'المتاجر النشطة',
        value: '98',
        percent: '4%',
        subtitle: 'مقارنة بالشهر الماضي',
      ),
      StatCard(
        title: 'طلبات جديدة',
        value: '245',
        percent: '10%',
        subtitle: 'مقارنة بالشهر الماضي',
      ),
      StatCard(
        title: 'المتاجر المرفوضة',
        value: '7',
        percent: '-2%',
        subtitle: 'مقارنة بالشهر الماضي',
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
                  "إدارة السوبرماركت",
                  style: TextStyle(color: Constants.primary, fontSize: 15),
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

              // جدول المستخدمين
              CustomDataTable2(
                controller: controller,
              )

            ],
          ),
        ),
      ),
    );
  }
}
