import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/users/user_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/custom_card.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.put(UserController());

    final List<Widget> statCards = const [
      StatCard(
        title: 'Total Users',
        value: '1,245',
        percent: '8%',
        subtitle: 'Compared to last month',
      ),
      StatCard(
        title: 'Active Users',
        value: '984',
        percent: '5%',
        subtitle: 'Compared to last month',
      ),
      StatCard(
        title: 'New Signups',
        value: '124',
        percent: '12%',
        subtitle: 'Compared to last month',
      ),
      StatCard(
        title: 'Banned Users',
        value: '15',
        percent: '-3%',
        subtitle: 'Compared to last month',
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
                  "إدارة المستخدمين",
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
              CustomDataTable(
                controller: controller,
                addButtonText: "إضافة مستخدم",
                onAddPressed: () {
                  print("تم الضغط على إضافة مستخدم");
                },
              )

            ],
          ),
        ),
      ),
    );
  }
}
