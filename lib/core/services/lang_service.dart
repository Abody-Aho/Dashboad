import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LangService {
  static const key = "app_lang";

  static Future<void> saveLang(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, lang);
  }

  static Future<Locale> getSavedLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString(key);
    return Locale(lang ?? "ar");
  }
}
