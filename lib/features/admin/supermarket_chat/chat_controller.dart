import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/chat_message.dart';
import '../../../data/models/supermarket.dart';

class ChatController extends GetxController {

  var markets = <SuperMarket>[
    SuperMarket(id: 1, name: "Super Fresh", image: ""),
    SuperMarket(id: 2, name: "Green Market", image: ""),
    SuperMarket(id: 3, name: "City Market", image: ""),
    SuperMarket(id: 4, name: "Family Store", image: ""),
  ].obs;

  var selectedMarket = 0.obs;

  var messages = <ChatMessage>[
    ChatMessage(
        text: "مرحبا نحتاج تحديث المنتجات",
        isAdmin: false,
        time: DateTime.now()),
    ChatMessage(
        text: "تم التحديث شكرا",
        isAdmin: true,
        time: DateTime.now()),
  ].obs;

  TextEditingController messageController = TextEditingController();

  void selectMarket(int index) {
    selectedMarket.value = index;
  }

  void sendMessage() {

    if (messageController.text.isEmpty) return;

    messages.add(ChatMessage(
      text: messageController.text,
      isAdmin: true,
      time: DateTime.now(),
    ));

    messageController.clear();
  }
}