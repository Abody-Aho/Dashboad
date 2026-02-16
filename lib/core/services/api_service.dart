import 'dart:convert';
import 'dart:io';
import 'package:dashbord2/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../constants/app_link.dart';

class ApiServices {
  // رابط الـ API الرئيسي

  static Future<Map<String, dynamic>> signUp({
    required UserModel user,
    String? location, // خاص بالسوبرماركت
    String? time_open, // خاص بالسوبرماركت
    File? imageFile, // صورة اختيارية
  }) async {
    try {
      final authUri = Uri.parse(AppLink.signup);
      final request = http.MultipartRequest('POST', authUri);

      request.fields['firebase_uid'] = user.firebaseUid;
      request.fields['name'] = user.name;
      request.fields['email'] = user.email;
      request.fields['role'] = user.role;
      request.fields['phone'] = user.phone;

      if (location != null && location.isNotEmpty)
        request.fields['location'] = location;
      if (time_open != null && time_open.isNotEmpty)
        request.fields['time_open'] = time_open;

      // رفع الصورة إذا وجدت
      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            filename: basename(imageFile.path),
          ),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      return Map<String, dynamic>.from(jsonDecode(respStr));
    } catch (e) {
      print("Error in signUp: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }

  //  جلب بيانات المستخدم

  static Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final uri = Uri.parse('${AppLink.login}?firebase_uid=$uid');
      final response = await http.get(uri);
      return Map<String, dynamic>.from(jsonDecode(response.body));
    } catch (e) {
      print("Error in getUserData: $e");
      return {'status': 'error', 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> adminAddUser({
    required String role,
    required String name,
    String? email,
    required String phone,
    String? firebaseUid,
    String? location,
    String? timeOpen,
    String? vehicleNumber,
    required String name_ar,
  }) async {
    try {
      var url = Uri.parse(
        AppLink.createAccount,
      );

      var response = await http.post(
        url,
        body: {
          "role": role,
          "name": name,
          "name_ar": name_ar,
          "email": email ?? "",
          "phone": phone,
          "firebase_uid": firebaseUid ?? "",
          "location": location ?? "",
          "time_open": timeOpen ?? "",
          "vehicle_number": vehicleNumber ?? "", // أضفناه للمندوب
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": "error",
          "message": "Server Error: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}
