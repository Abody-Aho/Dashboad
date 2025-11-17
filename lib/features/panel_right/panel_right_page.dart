import 'package:dashbord2/features/panel_right/wiggte_graph.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class Product {
  String name;
  bool enable;

  Product({required this.name, this.enable = true});
}

class PanelRightPage extends StatefulWidget {
  const PanelRightPage({super.key});

  @override
  State<PanelRightPage> createState() => _PanelRightPageState();
}

class _PanelRightPageState extends State<PanelRightPage> {
  final List<Product> _products = [
    Product(name: "LED Submersible Lights", enable: true),
    Product(name: "Wireless Headphones", enable: true),
    Product(name: "Smart Watch Series 8", enable: false),
    Product(name: "Bluetooth Speaker", enable: true),
    Product(name: "USB-C Fast Charger", enable: true),
    Product(name: "Portable Power Bank", enable: false),
    Product(name: "Gaming Mouse RGB", enable: true),
    Product(name: "Mechanical Keyboard", enable: true),
    Product(name: "HDMI Cable 2M", enable: false),
    Product(name: "Smart Home Plug", enable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- بطاقة الإيرادات ---
            Padding(
              padding: const EdgeInsets.all(Constants.kPadding),
              child: Container(
                decoration: BoxDecoration(
                  gradient: Constants.greenGradient, // نفس التدرج الجميل
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  title: const Text(
                    "Net Revenue",
                    style: TextStyle(
                      color: Constants.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: const Text(
                    "7% of Sales Avg",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Chip(
                    backgroundColor: Colors.white24,
                    label: const Text(
                      r"$46,450",
                      style: TextStyle(
                        color: Constants.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            LineChartSample1(),
            // قائمة المنتجات
            Padding(
              padding: const EdgeInsets.only(
                left: Constants.kPadding / 2,
                right: Constants.kPadding / 2,
                top: Constants.kPadding,
                bottom: Constants.kPadding,
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [
                      Constants.backgroundColor2,
                      Constants.backgroundColor1,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: List.generate(
                    _products.length,
                        (index) => SwitchListTile.adaptive(
                          activeThumbColor: Constants.success, // لون المقبض عند التشغيل
                          activeTrackColor: Constants.success.withValues(alpha: 0.5), // لون المسار النشط (اختياري)
                          inactiveTrackColor: Colors.white24,
                      title: Text(
                        _products[index].name,
                        style: const TextStyle(
                          color: Constants.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: _products[index].enable,
                      onChanged: (newValue) {
                        setState(() {
                          _products[index].enable = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
