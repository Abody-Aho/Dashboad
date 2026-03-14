import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'linear_graph.dart';

class Person {
  String name;
  Color color;

  Person({required this.name, required this.color});
}

class PanelCenterPage extends StatefulWidget {
  const PanelCenterPage({super.key});

  @override
  State<PanelCenterPage> createState() => _PanelCenterPageState();
}

class _PanelCenterPageState extends State<PanelCenterPage> {
  final List<Person> _persons = [
    Person(name: "person1".tr, color: Colors.red),
    Person(name: "person2".tr, color: Colors.pink),
    Person(name: "person3".tr, color: Colors.blue),
    Person(name: "person4".tr, color: Colors.yellow),
    Person(name: "person5".tr, color: Colors.orange),
    Person(name: "person6".tr, color: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- بطاقة المنتجات ---
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
                    "products_available".tr,
                    style: const TextStyle(
                      color: Constants.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "products_available_percent".tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Chip(
                    backgroundColor: Colors.white24,
                    label: Text(
                      "20500_value".tr,
                      style: const TextStyle(
                        color: Constants.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // --- الرسم البياني ---
            BarChartSample2(),

            // --- قائمة الأشخاص ---
            Padding(
              padding: const EdgeInsets.only(
                left: Constants.kPadding / 2,
                right: Constants.kPadding / 2,
                top: Constants.kPadding / 2,
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
                    _persons.length,
                        (index) => ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: _persons[index].color,
                        child: Text(
                          _persons[index].name.substring(0, 1),
                          style: const TextStyle(color: Constants.white),
                        ),
                      ),
                      title: Text(
                        _persons[index].name,
                        style: TextStyle(
                          color: Constants.text,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.message, color: Constants.accent),
                      ),
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
