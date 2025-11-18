import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/responsive_layout.dart';
import 'circle_graph.dart';
import 'curved_chart.dart';

class Todo {
  String name;
  bool enable;
  Todo({this.enable = true, required this.name});
}

class PanelLiftPage extends StatefulWidget {
  const PanelLiftPage({super.key});

  @override
  _PanelLeftPageState createState() => _PanelLeftPageState();
}

class _PanelLeftPageState extends State<PanelLiftPage> {
  final List<Todo> _todos = [
    Todo(name: "purchase_paper".tr, enable: true),
    Todo(name: "refill_speakers".tr, enable: true),
    Todo(name: "hire_someone".tr, enable: true),
    Todo(name: "marketing_strategy".tr, enable: true),
    Todo(name: "selling_furniture".tr, enable: true),
    Todo(name: "finish_disclosure".tr, enable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor1,
      body: Stack(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              width: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Constants.backgroundColor1, Constants.backgroundColor2]),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
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
                        "products_sold".tr,
                        style: const TextStyle(
                          color: Constants.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "products_sold_percent".tr,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      trailing: Chip(
                        backgroundColor: Colors.white24,
                        label: Text(
                          "4500_value".tr,
                          style: const TextStyle(
                            color: Constants.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                LineChartSample2(),
                PieChartSample2(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.kPadding,
                    vertical: Constants.kPadding / 2,
                  ),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                          _todos.length,
                              (index) => CheckboxListTile(
                            activeColor: Constants.primary,
                            checkColor: Constants.white,
                            title: Text(
                              _todos[index].name,
                              style: TextStyle(
                                color: _todos[index].enable
                                    ? Constants.primary
                                    : Constants.grey,
                                fontWeight: _todos[index].enable
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            value: _todos[index].enable,
                            onChanged: (newValue) {
                              setState(() {
                                _todos[index].enable = newValue ?? true;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
