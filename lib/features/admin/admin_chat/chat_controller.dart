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
  var filteredMarkets = <SuperMarket>[].obs;
  TextEditingController searchController = TextEditingController();

  int roomId = 0;

  TextEditingController messageController = TextEditingController();

  //  سكروول
  ScrollController scrollController = ScrollController();

  Timer? timer;

  String get lang => Get.locale?.languageCode ?? "ar";
  var hasSelectedChat = false.obs;

  @override
  void onInit() {
    super.onInit();

    final user = Get.find<AuthController>().currentUser.value!;
    adminId = user.id!;

    loadMarkets();
  }

  Future<void> loadMarkets() async {

    int? currentMarketId;

    if (markets.isNotEmpty) {
      currentMarketId = markets[selectedMarket.value].id;
    }

    var res = await http.get(
      Uri.parse(AppLink.getSupermarkets),
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
    );
    var data = jsonDecode(res.body);

    if (data["status"] == "success") {

      markets.value = List.generate(
        data["data"].length,
            (i) => SuperMarket.fromJson(data["data"][i]),
      );

      filteredMarkets.value = markets;

      if (currentMarketId != null) {
        int index = markets.indexWhere((m) => m.id == currentMarketId);

        if (index != -1) {
          selectedMarket.value = index;
        }
      }

    }
  }

  void searchMarkets(String query) {
    if (query.isEmpty) {
      filteredMarkets.value = markets;
    } else {
      filteredMarkets.value = markets.where((m) {
        return m.getName(lang).toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  Future<void> initChat() async {

    int marketId = markets[selectedMarket.value].id;

    var res = await http.get(
      Uri.parse("${AppLink.getOrCreateRoom}?supermarket_id=$marketId"),
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
    );

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
    hasSelectedChat.value = true;
    initChat();
  }

  // تحميل الرسائل
  Future<void> loadMessages() async {

    var res = await http.get(
      Uri.parse("${AppLink.getMessage}?room_id=$roomId&role=admin"),
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
    );

    var data = jsonDecode(res.body);

    if (data["status"] == "success") {

      messages.clear();

      for (var item in data["data"]) {
        messages.add(
          AdminChatMessage(
            id: item["message_id"],
            text: item["message"],
            isAdmin: item["sender_role"] == "admin",
            time: DateTime.parse(item["created_at"]),
          ),
        );
      }


      scrollToBottom();
    }
  }



  Future<void> deleteMessage(int messageId, String role) async {
    await http.post(
      Uri.parse(AppLink.deleteMessage),
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
      body: {
        "message_id": messageId.toString(),
        "sender_role": role,
      },
    );

    await loadMessages();
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
      headers: {
        "X-API-KEY": "aX9#pL@2026",
      },
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