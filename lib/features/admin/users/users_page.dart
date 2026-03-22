import 'package:dashbord2/core/constants/app_constants.dart';
import 'package:dashbord2/features/admin/users/user_controller.dart';
import 'package:dashbord2/features/widgets/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_bottom.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_dropdown_button.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/responsive_grid.dart';
import '../../widgets/user_account_form.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = Get.find<UserController>();

    // بطاقات الإحصائيات / Statistics Cards
    List<Widget> statCards = [
      StatCard(
        title: 'total_users'.tr, // مترجم
        value: '1,245',
        percent: '8%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'active_users'.tr,
        value: '984',
        percent: '5%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'new_signups'.tr,
        value: '124',
        percent: '12%',
        subtitle: 'compared_last_month'.tr,
      ),
      StatCard(
        title: 'banned_users'.tr,
        value: '15',
        percent: '-3%',
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
              // العنوان / Page Title
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'user_management'.tr,
                  style: TextStyle(
                    color: Constants.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // بطاقات الإحصائيات / Statistics Cards Layout
              ResponsiveGrid(
                itemCount: statCards.length,
                itemBuilder: (context, index) => statCards[index],
              ),
              const SizedBox(height: 20),

              // جدول المستخدمين مع الخلفية المستديرة / Users Table with Rounded Background
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),

                      // الصف العلوي (زر + قائمة + بحث) / Top Row (Button + Dropdown + Search)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isPhone = constraints.maxWidth < 600;

                          if (isPhone) {
                            // عمودي / Vertical layout
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
                                    onChanged: (value) {
                                      controller.filterByType(value);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 11),
                                  child: CustomBottom(
                                    controller: controller,
                                    addButtonText: 'add_users'.tr,
                                    onAddPressed: () {
                                      controller.resetUserDialogState();
                                      showCreateAccountDialog(
                                        context: context,
                                        formKey: formKey,
                                        controller: controller,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          } else {
                            // أفقي / Horizontal layout
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomBottom(
                                  controller: controller,
                                  addButtonText: 'add_users'.tr,
                                  onAddPressed: () {
                                    controller.resetUserDialogState();
                                    showCreateAccountDialog(
                                      context: context,
                                      formKey: formKey,
                                      controller: controller,
                                    );
                                  },
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 5.w),
                                  child: CustomDropdownButton(
                                    selectedValue: controller.selectedValue,
                                    options: controller.options,
                                    onChanged: (value) {
                                      controller.filterByType(value);
                                    },
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

                      Obx(() {
                        int selectedCount =
                            controller.selectedRows.where((e) => e).length;

                        if (selectedCount == 0) return SizedBox();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text("تم تحديد $selectedCount مستخدم"),
                                const SizedBox(width: 20),

                                ElevatedButton.icon(
                                  icon: Icon(Icons.check_circle,color: Colors.green,),
                                  label: Text("تفعيل",style: TextStyle(color: Colors.green),),
                                  onPressed: () =>
                                      controller.changeStatusForSelected("1"),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton.icon(
                                  icon: Icon(Icons.cancel,color: Colors.red,),
                                  label: Text("إلغاء التفعيل",style: TextStyle(color: Colors.red),),
                                  onPressed: () =>
                                      controller.changeStatusForSelected("0"),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  icon: Icon(Icons.delete,color: Colors.white,),
                                  label: Text("حذف",style: TextStyle(color: Colors.white),),
                                  onPressed: () =>
                                      controller.deleteSelectedUsers(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      // جدول المستخدمين / Users Table
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

  void showCreateAccountDialog({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required dynamic controller,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "create_account".tr,
            style: TextStyle(
              color: Colors.green[700],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 600,
            height: 600,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: UserAccountForm(controller: controller),
              ),
            ),
          ),
          actions: [
            // زر إلغاء
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                minimumSize: const Size(50, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "cancel".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            // زر إنشاء الحساب
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                  minimumSize: const Size(50, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          await controller.addAccount();
                        }
                      },
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "create_account".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}
