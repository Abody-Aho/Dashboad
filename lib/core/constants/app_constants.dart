import 'package:flutter/material.dart';

class Constants {
  //  المسافات العامة
  static const double kPadding = 10.0;

  //  الألوان الأساسية (الخضراء)
  static const Color background = Color(0xFFF4FBF4); // أخضر باهت
  static const Color white = Colors.white;
  static const Color primary = Color(0xFF2E7D32); // أخضر غامق
  static final Color backgroundColor1 = Colors.green.shade50;
  static final Color backgroundColor2 = Colors.green.shade100;
  static const Color accent = Color(0xFF7BC47F); // أخضر فاتح
  static const Color text = Color(0xFF2B3A2B);

  //  ألوان إضافية مفيدة
  static const Color success = Color(0xFF4CAF50); // نجاح
  static const Color warning = Color(0xFFFFC107); // تحذير
  static const Color error = Color(0xFFF44336);   // خطأ
  static const Color info = Color(0xFF2196F3);    // معلومات

  //  ألوان ثانوية ومحايدة
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF616161);

  //  ألوان للخلفيات الثانوية أو التظليل
  static const Color backgroundLight = Color(0xFFF9FFF9); // أفتح من background
  static const Color backgroundDark = Color(0xFFE8F5E9);  // أخضر فاتح جدًا
  static const Color shadow = Color(0x33000000);          // ظل خفيف (20%)

  //  تدرجات لونية (يمكن تستخدمها في الخلفيات)
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF7BC47F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradientlight = LinearGradient(
    colors: [
      Color(0xFF81C784), // أخضر متوسط لطيف
      Color(0xFFA5D6A7), // أخضر فاتح
      Color(0xFFC8E6C9), // أخضر باهت قريب من الأبيض
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.2, 0.6, 1.0],
  );
  static const LinearGradient greyGradient = LinearGradient(
    colors: [Color(0xFFE0E0E0), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
