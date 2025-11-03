class AuthService {
  static Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));


    if (email == "admin@gmail.com" && password == "123456") {
      return true;
    }
    return false;
  }
}
