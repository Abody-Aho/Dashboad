import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/lang_service.dart';

InputDecoration inputDecoration({String? hint, IconData? icon, Widget? suffix}) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.green, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: Colors.green, width: 2.5),
    ),
    hintText: hint,
    prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
    suffixIcon: suffix,
  );
}


Widget topIconButton({required IconData icon, required VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.green[800], size: 24),
    ),
  );
}

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green[100],
            radius: 30,
            child: Icon(Icons.support_agent, color: Colors.green[900], size: 35),
          ),
          const SizedBox(height: 15),
          Text(
            "support_title".tr, // "الدعم الفني"
            style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "support_desc".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          // بريد الإدمن
          buildContactTile(
            icon: Icons.email_outlined,
            title: "abdalwalysamer6@example.com",
            subtitle: "email".tr,
          ),
          const SizedBox(height: 10),
          // رقم الإدمن
          buildContactTile(
            icon: Icons.phone_android_outlined,
            title: "+967 778498987",
            subtitle: "phone".tr,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("close".tr, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

Widget buildContactTile({required IconData icon, required String title, required String subtitle}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.green.withOpacity(0.2)),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.green[700]),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[900])),
            ],
          ),
        ),
      ],
    ),
  );
}

void changeLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
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
            const Divider(color: Colors.greenAccent), // خط فاصل أنيق

            // خيار اللغة العربية
            buildLanguageOption(
              context: context,
              title: "العربية",
              localeCode: "ar",
              icon: Icons.translate_rounded,
              isSelected: Get.locale?.languageCode == "ar",
            ),

            const SizedBox(height: 8),

            // خيار اللغة الإنجليزية
            buildLanguageOption(
              context: context,
              title: "English",
              localeCode: "en",
              icon: Icons.abc_rounded,
              isSelected: Get.locale?.languageCode == "en",
            ),
          ],
        ),
      ),
      // إضافة زر إغلاق بسيط
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("close".tr, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    ),
  );
}

Widget buildLanguageOption({
  required BuildContext context,
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
  );}