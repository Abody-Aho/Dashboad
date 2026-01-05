import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../panel_center/panel_center_page.dart';
import '../panel_lift/panel_lift_page.dart';
import '../panel_right/panel_right_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 1;
  int currentIndex2 = 0;

  final List<Widget> _icons = [
    Icon(Icons.add, size: 30),
    Icon(Icons.list, size: 30),
    Icon(Icons.compare_arrows, size: 30),
  ];
  final List<Widget> _icons2 = [
    Icon(Icons.add, size: 30),
    Icon(Icons.compare_arrows, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        tiny: Container(),
        phone: currentIndex == 0
            ? PanelLiftPage()
            : currentIndex == 1
            ? PanelCenterPage()
            : PanelRightPage(),
        tablet: currentIndex2 == 0
            ? Row(
          children: [
            Expanded(child: PanelLiftPage()),
            Expanded(child: PanelCenterPage()),
          ],
        )
            : Row(
          children: [
            Expanded(child: PanelCenterPage()),
            Expanded(child: PanelRightPage()),
          ],
        ),
        largeTablet: Row(
          children: [
            Expanded(child: PanelLiftPage()),
            Expanded(child: PanelCenterPage()),
            Expanded(child: PanelRightPage()),
          ],
        ),
        computer: Row(
          children: [
            Expanded(child: PanelLiftPage()),
            Expanded(child: PanelCenterPage()),
            Expanded(child: PanelRightPage()),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveLayout.isPhone(context)
          ? CurvedNavigationBar(
        items: _icons,
        index: currentIndex,
        backgroundColor: Constants.backgroundDark,
        color: Constants.accent,
        buttonBackgroundColor: Constants.accent,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      )
          : ResponsiveLayout.isTablet(context)
          ? CurvedNavigationBar(
        items: _icons2,
        index: currentIndex2,
        backgroundColor: Constants.backgroundDark,
        color: Constants.accent,
        buttonBackgroundColor: Constants.accent,
        onTap: (index) {
          setState(() {
            currentIndex2 = index;
          });
        },
      )
          : SizedBox(),
    );
  }
}
