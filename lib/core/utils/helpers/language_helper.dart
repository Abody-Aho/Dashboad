import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/lang_service.dart';

class LanguageHelper {

  static void changeLanguageDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.language, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              "choose_language".tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.greenAccent), // خط فاصل

              // خيار اللغة العربية
              _buildLanguageOption(
                title: "العربية",
                localeCode: "ar",
                icon: Icons.translate_rounded,
                isSelected: Get.locale?.languageCode == "ar",
              ),

              const SizedBox(height: 8),

              // خيار اللغة الإنجليزية
              _buildLanguageOption(
                title: "English",
                localeCode: "en",
                icon: Icons.abc_rounded,
                isSelected: Get.locale?.languageCode == "en",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // استخدام ميزة GetX للإغلاق
            child: Text("close".tr, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  static Widget _buildLanguageOption({
    required String title,
    required String localeCode,
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? Colors.green : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.green[800] : Colors.black87,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () async {
          Get.updateLocale(Locale(localeCode));
          await LangService.saveLang(localeCode);
          Get.back();
        },
      ),
    );
  }
}