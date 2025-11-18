import 'package:dashbord2/features/panel_right/wiggte_graph.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Product(name: "led_lights".tr, enable: true),
    Product(name: "wireless_headphones".tr, enable: true),
    Product(name: "smart_watch".tr, enable: false),
    Product(name: "speaker".tr, enable: true),
    Product(name: "charger".tr, enable: true),
    Product(name: "power_bank".tr, enable: false),
    Product(name: "mouse".tr, enable: true),
    Product(name: "keyboard".tr, enable: true),
    Product(name: "hdmi".tr, enable: false),
    Product(name: "smart_plug".tr, enable: true),
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
                  gradient: Constants.greenGradient,
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
                  title: Text(
                    "net_revenue".tr,
                    style: const TextStyle(
                      color: Constants.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "sales_avg".tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Chip(
                    backgroundColor: Colors.white24,
                    label: Text(
                      r"$46,450",
                      style: const TextStyle(
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
                  gradient: LinearGradient(
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
                      activeThumbColor: Constants.success,
                      activeTrackColor: Constants.success.withValues(alpha: 0.5),
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
