import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import 'chat_controller.dart';

class AdminChatPage extends StatelessWidget {

  final ChatController controller = Get.put(ChatController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        bool isMobile = constraints.maxWidth < 800;

        return Scaffold(

          key: scaffoldKey,

          backgroundColor: Constants.waChatBackground,

          drawer: isMobile ? _sidebar(isMobile) : null,

          body: SafeArea(
            child: Row(
              children: [

                if (!isMobile) _sidebar(isMobile),

                Expanded(
                  child: Column(
                    children: [

                      _header(isMobile),

                      Expanded(child: _messages()),

                      _input(),

                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// HEADER
  Widget _header(bool isMobile) {

    return Container(

      height: 65,

      padding: const EdgeInsets.symmetric(horizontal: 8),

      decoration: const BoxDecoration(
        color: Constants.waSidebar,
        border: Border(
          bottom: BorderSide(
            color: Constants.waBorder,
          ),
        ),
      ),

      child: Row(
        children: [

          /// زر الرجوع (دائماً ظاهر)
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),

          /// زر القائمة للموبايل
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu,
                  color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
            ),

          const SizedBox(width: 4),

          const CircleAvatar(
            radius: 20,
            backgroundColor: Constants.primary,
            child: Icon(Icons.store,color: Colors.white),
          ),

          const SizedBox(width: 10),

          Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                controller.markets[
                controller.selectedMarket.value].name,

                style: const TextStyle(
                    color: Constants.waText,
                    fontWeight: FontWeight.bold),
              ),

              const Text(
                "online",
                style: TextStyle(
                    fontSize: 12,
                    color: Constants.waTextSecondary),
              )
            ],
          )),

          const Spacer(),

          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search,
                  color: Colors.white)),

          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert,
                  color: Colors.white))
        ],
      ),
    );
  }

  /// SIDEBAR
  Widget _sidebar(bool isMobile) {

    return Container(

      width: 300,

      color: Constants.waSidebar,

      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,

            child: const Text(
              "Chats",

              style: TextStyle(
                  fontSize: 18,
                  color: Constants.waText,
                  fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(color: Constants.waBorder),

          Expanded(
            child: Obx(() => ListView.builder(

              itemCount: controller.markets.length,

              itemBuilder: (context, index) {

                final market = controller.markets[index];

                return ListTile(

                  leading: const CircleAvatar(
                    backgroundColor: Constants.primary,
                    child: Icon(Icons.store,
                        color: Colors.white),
                  ),

                  title: Text(
                    market.name,
                    style: const TextStyle(
                        color: Constants.waText),
                  ),

                  subtitle: const Text(
                    "Tap to chat",
                    style: TextStyle(
                        fontSize: 12,
                        color: Constants.waTextSecondary),
                  ),

                  selected:
                  controller.selectedMarket.value ==
                      index,

                  selectedTileColor:
                  Constants.waBorder,

                  onTap: () {

                    controller.selectMarket(index);

                    if (isMobile) Get.back();
                  },
                );
              },
            )),
          )
        ],
      ),
    );
  }

  /// MESSAGES
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

            margin:
            const EdgeInsets.symmetric(vertical: 4),

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

            child: Text(
              msg.text,
              style: const TextStyle(
                  fontSize: 14,
                  color: Constants.waText),
            ),
          ),
        );
      },
    ));
  }

  /// INPUT
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

          IconButton(
              onPressed: () {},
              icon: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.white)),

          Expanded(
            child: TextField(

              controller: controller.messageController,

              style: const TextStyle(
                  color: Constants.waText),

              decoration: InputDecoration(

                hintText: "Type a message",

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