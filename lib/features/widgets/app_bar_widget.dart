import 'package:dashbord2/features/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

List<String> _buttonNames = ["Overview", "Revenue", "Sales", "Control"];
int _currentSelectedButton = 0;

class AppBarWidget extends StatefulWidget {
  const AppBarWidget({super.key});

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[50],
      child: Row(
        children: [
          if (ResponsiveLayout.isComputer(context))
            Container(
              margin: const EdgeInsets.all(Constants.kPadding),
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Constants.shadow,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Constants.backgroundDark,
                radius: 30,
                child: Image.asset("images/mapp.png"),
              ),
            )
          else
            IconButton(
              color: Constants.primary,
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),

          const SizedBox(width: Constants.kPadding),

          if (ResponsiveLayout.isComputer(context))
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Constants.primary,
                side: const BorderSide(color: Constants.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(Constants.kPadding / 2),
                child: Text("Admin Panel"),
              ),
            ),

          const Spacer(),

          if (ResponsiveLayout.isComputer(context))
            ...List.generate(
              _buttonNames.length,
                  (index) => TextButton(
                onPressed: () {
                  setState(() {
                    _currentSelectedButton = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.kPadding * 2,
                      vertical: Constants.kPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _buttonNames[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _currentSelectedButton == index
                              ? Constants.primary
                              : Constants.accent,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(top: 5),
                        width: 60,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: _currentSelectedButton == index
                              ? Constants.greenGradient
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(Constants.kPadding * 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _buttonNames[_currentSelectedButton],
                    style: const TextStyle(
                      color: Constants.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 60,
                    height: 2,
                    decoration: const BoxDecoration(
                      gradient: Constants.greenGradient,
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),

          IconButton(
            color: Constants.primary,
            iconSize: 28,
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),

          Stack(
            children: [
              IconButton(
                color: Constants.primary,
                iconSize: 28,
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  backgroundColor: Constants.error,
                  radius: 8,
                  child: const Text(
                    "3",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          if (!ResponsiveLayout.isPhone(context))
            Container(
              margin: const EdgeInsets.all(Constants.kPadding),
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Constants.shadow,
                    offset: const Offset(0, 2),
                    spreadRadius: 1,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Constants.background,
                radius: 30,
                backgroundImage: AssetImage("images/profile.png"),
              ),
            ),
        ],
      ),
    );
  }
}
