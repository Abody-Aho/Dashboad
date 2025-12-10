import 'package:flutter/material.dart';

class MarketDashboardView extends StatelessWidget {
  const MarketDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green,),
      body: Center(child: Text("market_dashboard"),),
    );
  }
}
