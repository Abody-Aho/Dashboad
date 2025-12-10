// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../../data/models/user_model.dart';
//
// class AuthService {
//   static const String baseUrl = "http://localhost/flymarket/auth/";
//
//   // تسجيل الدخول
//   static Future<bool> login(String email, String password) async {
//     final url = Uri.parse("$baseUrl/login.php");
//     final response = await http.post(url, body: {
//       'email': email,
//       'password': password,
//     });
//
//     if(response.statusCode == 200){
//       final data = json.decode(response.body);
//       return data['status'] == 'success';
//     }
//     return false;
//   }
//
//   // تسجيل حساب جديد
//   static Future<void> registerUser(UserModel user, String role) async {
//     final url = Uri.parse("$baseUrl/sinup.php");
//     final request = http.MultipartRequest('POST', url);
//
//     request.fields['firebase_uid'] = user.firebaseUid;
//     request.fields['name'] = user.name;
//     request.fields['email'] = user.email;
//     request.fields['phone'] = user.phone;
//     request.fields['role'] = role;
//
//     final response = await request.send();
//     final respStr = await response.stream.bytesToString();
//     final data = json.decode(respStr);
//
//     if(data['status'] != 'success'){
//       throw Exception(data['message']);
//     }
//   }
// }
