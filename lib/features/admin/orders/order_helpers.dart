import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'orders_controller.dart';

mixin OrderHelpers on GetxController{
  OrdersController get controller;

  Widget infoRow(String title, String value) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}
