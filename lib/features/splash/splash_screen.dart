import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'splash_controller.dart'; // مسار ملف الكنترولر

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  // استدعاء الكنترولر بمجرد فتح الشاشة
  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // تدرج لوني أخضر احترافي
          gradient: LinearGradient(
            colors: [
              Color(0xFF1B5E20), // أخضر غامق
              Color(0xFF4CAF50), // أخضر فاتح
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🛒 أيقونة عربة التسوق مع أنيميشن مركب
            const Icon(
              Icons.shopping_cart_checkout_rounded,
              size: 120,
              color: Colors.white,
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack) // انبثاق مرن
                .then(delay: 200.ms)
                .shake(hz: 4, duration: 800.ms,) // اهتزاز خفيف كأن العربة تتحرك
                .then(delay: 400.ms)
                .slideX(end: 2, duration: 600.ms, curve: Curves.easeInOut) // خروج العربة من الشاشة
                .fadeOut(duration: 400.ms),

            const SizedBox(height: 30),

            // ✨ نص اسم النظام مع تأثيرات الظهور واللمعان
            const Text(
              "نظام إدارة السوبرماركت",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            )
                .animate()
                .fadeIn(duration: 1000.ms, curve: Curves.easeIn)
                .slideY(begin: 0.5, end: 0, duration: 800.ms)
                .then()
                .shimmer(duration: 1200.ms, color: Colors.greenAccent), // لمعان احترافي على النص

            const SizedBox(height: 10),

            // 📦 نص فرعي يظهر متأخراً قليلاً
            const Text(
              "أداء سريع .. تحكم كامل",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            )
                .animate(delay: 800.ms) // يتأخر حتى يظهر النص الرئيسي
                .fadeIn(duration: 800.ms)
                .scale(),
          ],
        ),
      ),
    );
  }
}