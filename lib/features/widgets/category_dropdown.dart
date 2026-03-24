import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/category_all_model.dart';

class CategoryDropdown extends StatelessWidget {
  final RxList<CategoryAllModel> categories;
  final Rxn<CategoryAllModel> selectedCategory;
  final Function(CategoryAllModel?) onChanged;

  // إعدادات التصميم (يمكنك تغييرها من هنا)
  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final IconData icon;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    this.height = 35,
    this.backgroundColor = const Color(0xFFE6F2EC),
    this.borderColor = Colors.green,
    this.icon = Icons.keyboard_arrow_down,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categories.isEmpty) {
        return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }

      return Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CategoryAllModel?>(
            value: selectedCategory.value,
            icon: Icon(icon, color: borderColor),
            isExpanded: false, // اجعلها true إذا أردت العرض كاملاً
            items: [
              const DropdownMenuItem<CategoryAllModel?>(
                value: null,
                child: Text("كل الفئات"),
              ),
              ...categories.map((cat) {
                return DropdownMenuItem<CategoryAllModel?>(
                  value: cat,
                  child: Text(cat.nameAr),
                );
              }),
            ],
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      );
    });
  }
}