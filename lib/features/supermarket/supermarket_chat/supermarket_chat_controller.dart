import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/app_link.dart';
import '../../../data/models/supermarket_chat_message.dart';
import '../../auth/auth_controller.dart';

class SupermarketChatController extends GetxController {

  final ScrollController scrollController = ScrollController();

  late int supermarketId;
  late String supermarketName;

  int roomId = 0;
  Timer? timer;

  var messages = <SupermarketChatMessage>[].obs;

  TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    final user = Get.find<AuthController>().currentUser.value!;

    supermarketId = user.id!;
    supermarketName = user.name;

    initChat();
  }

  Future<void> initChat() async {

    var res = await http.get(Uri.parse(
        "${AppLink.getOrCreateRoom}?supermarket_id=$supermarketId"
    ));

    var data = jsonDecode(res.body);

    roomId = data["room_id"];

    await loadMessages();

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      loadMessages();
    });
  }

  /// 🔥 جلب الرسائل
  Future<void> loadMessages() async {

    var res = await http.get(Uri.parse(
        "${AppLink.getMessage}?room_id=$roomId"
    ));

    var data = jsonDecode(res.body);

    if (data["status"] == "success") {

      messages.clear();

      for (var item in data["data"]) {

        messages.add(
          SupermarketChatMessage(
            id: item["message_id"],
            text: item["message"],
            senderName: item["sender_name"],
            isAdmin: item["sender_role"] == "supermarket",
            time: DateTime.parse(item["created_at"]),
          ),
        );
      }

      scrollToBottom();
    }
  }

  Future<void> deleteMessage(int messageId) async {
    await http.post(
      Uri.parse(AppLink.deleteMessage),
      body: {
        "message_id": messageId.toString(),
        "sender_role": "supermarket",
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

    if (messageController.text.trim().isEmpty) return;

    await http.post(
      Uri.parse(AppLink.sendMessage),
      body: {
        "room_id": roomId.toString(),
        "sender_id": supermarketId.toString(),
        "sender_role": "supermarket",
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