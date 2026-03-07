import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'orders_controller.dart';

mixin OrderTable on GetxController{
  OrdersController get controller;
}
