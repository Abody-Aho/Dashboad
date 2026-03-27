import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/app_link.dart';
import '../../../data/models/admin_chat_message.dart';
import '../../../data/models/supermarket.dart';
import '../../auth/auth_controller.dart';

class ChatController extends GetxController {

  late int adminId;
  var markets = <SuperMarket>[].obs;
  var selectedMarket = 0.obs;

  var messages = <AdminChatMessage>[].obs;

  int roomId = 0;

  TextEditingController messageController = TextEditingController();

  /// 🔥 سكروول
  ScrollController scrollController = ScrollController();

  Timer? timer;

  String get lang => Get.locale?.languageCode ?? "ar";

  @override
  void onInit() {
    super.onInit();

    final user = Get.find<AuthController>().currentUser.value!;
    adminId = user.id!;

    loadMarkets();
  }

  Future<void> loadMarkets() async {

    var res = await http.get(Uri.parse(AppLink.getSupermarkets));
    var data = jsonDecode(res.body);

    if (data["status"] == "success") {

      markets.value = List.generate(
        data["data"].length,
            (i) => SuperMarket.fromJson(data["data"][i]),
      );

      if (markets.isNotEmpty) {
        initChat();
      }
    }
  }

  Future<void> initChat() async {

    int marketId = markets[selectedMarket.value].id;

    var res = await http.get(Uri.parse(
        "${AppLink.getOrCreateRoom}?supermarket_id=$marketId"
    ));

    var data = jsonDecode(res.body);

    roomId = data["room_id"];

    await loadMessages();

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      loadMessages();
    });
  }

  void selectMarket(int index) {
    selectedMarket.value = index;
    initChat();
  }

  /// 🔥 تحميل الرسائل
  Future<void> loadMessages() async {

    var res = await http.get(Uri.parse(
        "${AppLink.getMessage}?room_id=$roomId"
    ));

    var data = jsonDecode(res.body);

    if (data["status"] == "success") {

      messages.clear();

      for (var item in data["data"]) {
        messages.add(
          AdminChatMessage(
            text: item["message"],
            isAdmin: item["sender_role"] == "admin",
            time: DateTime.parse(item["created_at"]),
          ),
        );
      }


      scrollToBottom();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage() async {

    if (messageController.text.isEmpty) return;

    await http.post(
      Uri.parse(AppLink.sendMessage),
      body: {
        "room_id": roomId.toString(),
        "sender_id": adminId.toString(),
        "sender_role": "admin",
        "message": messageController.text
      },
    );

    messageController.clear();

    await loadMessages();
  }

  @override
  void onClose() {
    timer?.cancel();
    scrollController.dispose();
    super.onClose();
  }
}