import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. ميدل وير للتحقق العام من تسجيل الدخول (لحماية كل الصفحات)
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}

// 2. ميدل وير خاص بالأدمن فقط
class AdminMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    final box = GetStorage();
    final userData = box.read("user");

    // إذا لم يسجل دخوله أصلاً
    if (user == null || userData == null) {
      return const RouteSettings(name: '/login');
    }

    // التحقق من الرتبة
    final role = userData['role'];
    if (role != 'admin') {
      // إذا لم يكن أدمن، نوجهه لصفحة السوبرماركت (أو صفحة غير مصرح له)
      return const RouteSettings(name: '/dashboardMarket');
    }

    return null;
  }
}

// 3. ميدل وير خاص بالسوبرماركت فقط
class SupermarketMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final user = FirebaseAuth.instance.currentUser;
    final box = GetStorage();
    final userData = box.read("user");

    // إذا لم يسجل دخوله أصلاً
    if (user == null || userData == null) {
      return const RouteSettings(name: '/login');
    }

    // التحقق من الرتبة
    final role = userData['role'];
    if (role != 'supermarket') {
      // إذا لم يكن سوبرماركت، نوجهه لصفحة الأدمن
      return const RouteSettings(name: '/dashboardAdmin');
    }

    return null;
  }
}