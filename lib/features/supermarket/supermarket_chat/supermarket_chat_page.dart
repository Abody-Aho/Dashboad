import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'supermarket_chat_controller.dart';

class SupermarketChatPage extends StatelessWidget {

  final SupermarketChatController controller =
  Get.find<SupermarketChatController>();

  SupermarketChatPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Constants.waChatBackground,

      body: SafeArea(
        child: Column(
          children: [

            _header(),

            Expanded(child: _messages()),

            _input(),

          ],
        ),
      ),
    );
  }

  /// 🔵 HEADER
  Widget _header() {

    return Container(

      height: 65,

      padding: const EdgeInsets.symmetric(horizontal: 12),

      decoration: const BoxDecoration(
        color: Constants.waSidebar,
        border: Border(
          bottom: BorderSide(color: Constants.waBorder),
        ),
      ),

      child: Row(
        children: [

          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white),
            onPressed: () => Get.back(),
          ),

          const CircleAvatar(
            radius: 20,
            backgroundColor: Constants.primary,
            child: Icon(Icons.store, color: Colors.white),
          ),

          const SizedBox(width: 10),

          /// 🔥 حل overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  controller.supermarketName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Constants.waText,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  "support chat",
                  style: TextStyle(
                    fontSize: 12,
                    color: Constants.waTextSecondary,
                  ),
                )
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert,
                color: Colors.white),
          )
        ],
      ),
    );
  }

  /// 🟢 الرسائل
  Widget _messages() {

    return Obx(() => ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: controller.messages.length,

      itemBuilder: (context, index) {

        final msg = controller.messages[index];

        bool isMe = msg.isAdmin;

        return Align(

          alignment: isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,

          child: Container(

            margin: const EdgeInsets.symmetric(vertical: 4),

            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),

            constraints:
            const BoxConstraints(maxWidth: 350),

            decoration: BoxDecoration(

              color: isMe
                  ? Constants.waBubbleMe
                  : Constants.waBubbleOther,

              borderRadius: BorderRadius.only(

                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),

                bottomLeft:
                Radius.circular(isMe ? 10 : 0),

                bottomRight:
                Radius.circular(isMe ? 0 : 10),
              ),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔥 اسم المرسل
                Text(
                  msg.senderName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 2),

                /// الرسالة
                Text(
                  msg.text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Constants.waText,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  /// 🟡 الإدخال
  Widget _input() {

    return Container(

      padding:
      const EdgeInsets.symmetric(
          horizontal: 10, vertical: 8),

      decoration: const BoxDecoration(
        color: Constants.waInput,
        border: Border(
          top: BorderSide(
              color: Constants.waBorder),
        ),
      ),

      child: Row(
        children: [

          Expanded(
            child: TextField(

              controller: controller.messageController,

              style: const TextStyle(
                  color: Constants.waText),

              decoration: InputDecoration(

                hintText: "اكتب رسالة",

                hintStyle: const TextStyle(
                    color: Constants.waTextSecondary),

                filled: true,

                fillColor: Constants.waBubbleOther,

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),

                contentPadding:
                const EdgeInsets.symmetric(
                    horizontal: 16),
              ),
            ),
          ),

          const SizedBox(width: 8),

          CircleAvatar(
            backgroundColor: Constants.primary,

            child: IconButton(
              icon: const Icon(Icons.send,
                  color: Colors.white),
              onPressed: controller.sendMessage,
            ),
          )
        ],
      ),
    );
  }
}