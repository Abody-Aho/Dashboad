import 'dart:convert';
import 'dart:io';
import 'package:dashbord2/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiServices {
  // رابط الـ API الرئيسي
  static const String baseUrl = 'http://localhost/flymarket/auth/';

  // 🔥 تسجيل حساب جديد (أدمن وسوبرماركت فقط)
  // ✅ تم التعديل لاستخدام UserModel مباشرة
  static Future<Map<String, dynamic>> signUp({
    required UserModel user,
    String? location,               // خاص بالسوبرماركت
    String? time_open,              // خاص بالسوبرماركت
    File? imageFile,                // صورة اختيارية
  }) async {
    try {
      final uri = Uri.parse('${baseUrl}signup.php');
      final request = http.MultipartRequest('POST', uri);

      // الحقول الأساسية من المودل
      request.fields['firebase_uid'] = user.firebaseUid;
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['role'] = user.role;
      request.fields['phone'] = user.phone;

      // الحقول الخاصة بالسوبرماركت
      if (location != null && location.isNotEmpty) request.fields['location'] = location;
      if (time_open != null && time_open.isNotEmpty) request.fields['time_open'] = time_open;

      // رفع الصورة إذا وجدت
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          filename: basename(imageFile.path),
        ));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      return Map<String, dynamic>.from(jsonDecode(respStr));
    } catch (e) {
      print("Error in signUp: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }

  // ===========================
  // 📦 جلب بيانات المستخدم
  // ===========================
  static Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      // ✅ تم تصحيح الخطأ: يجب استدعاء get_user.php
      final uri = Uri.parse('${baseUrl}get_user.php?uid=$uid');
      final response = await http.get(uri);
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      print("Error in getUserData: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }
}
