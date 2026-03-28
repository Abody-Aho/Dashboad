import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../routes/app_routes.dart';
import 'chat_controller.dart';

class AdminChatPage extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AdminChatPage({super.key});

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

  Widget _header(bool isMobile) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Constants.waSidebar,
        border: Border(
          bottom: BorderSide(color: Constants.waBorder),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              if (Get.routing.previous != '') {
                Get.back();
              } else {
                Get.offAllNamed(AppRoutes.dashboardAdmin);
              }
            },
          ),
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
          const SizedBox(width: 4),

          /// 🖼️ صورة السوبرماركت
          Obx(() {
            if (controller.markets.isEmpty) {
              return const CircleAvatar(
                radius: 20,
                backgroundColor: Constants.primary,
                child: Icon(Icons.store, color: Colors.white),
              );
            }

            final market = controller.markets[controller.selectedMarket.value];

            return CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              backgroundImage: market.image.isNotEmpty
                  ? NetworkImage("${AppLink.image}${market.image}")
                  : null,
              child: market.image.isEmpty
                  ? const Icon(Icons.store, color: Colors.white)
                  : null,
            );
          }),

          const SizedBox(width: 10),

          /// 🟢 الاسم حسب اللغة
          Expanded(
            child: Obx(() {
              if (controller.markets.isEmpty) {
                return const Text("...");
              }

              final market = controller.markets[controller.selectedMarket.value];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    market.getName(controller.lang),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Constants.waText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "active".tr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Constants.waTextSecondary,
                    ),
                  )
                ],
              );
            }),
          ),

          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white))
        ],
      ),
    );
  }

  /// 🟣 SIDEBAR
  Widget _sidebar(bool isMobile) {
    return Container(
      width: 300,
      color: Constants.waSidebar,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "chats".tr,
              style: const TextStyle(
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
                  /// 🖼️ صورة
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: market.image.isNotEmpty
                        ? NetworkImage("${AppLink.image}${market.image}")
                        : null,
                    child: market.image.isEmpty
                        ? const Icon(Icons.store, color: Colors.white)
                        : null,
                  ),

                  /// 🟢 اسم حسب اللغة
                  title: Text(
                    market.getName(controller.lang),
                    style: const TextStyle(color: Constants.waText),
                  ),
                  selected: controller.selectedMarket.value == index,
                  selectedTileColor: Constants.waBorder,
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

  /// 🟢 الرسائل
  Widget _messages() {
    return Obx(() => ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final msg = controller.messages[index];

        bool isMe = msg.isAdmin;

        return Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: const BoxConstraints(maxWidth: 350),
            decoration: BoxDecoration(
              color: isMe ? Constants.waBubbleMe : Constants.waBubbleOther,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10),
              ),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(fontSize: 14, color: Constants.waText),
            ),
          ),
        );
      },
    ));
  }

  /// 🟡 INPUT
  Widget _input() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Constants.waInput,
        border: Border(
          top: BorderSide(color: Constants.waBorder),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              textInputAction: TextInputAction.send,
              style: const TextStyle(color: Constants.waText),
              onSubmitted: (value) {
                controller.sendMessage();
              },
              decoration: InputDecoration(
                hintText: "type_message_hint".tr,
                hintStyle: const TextStyle(color: Constants.waTextSecondary),
                filled: true,
                fillColor: Constants.waBubbleOther,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Constants.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: controller.sendMessage,
            ),
          )
        ],
      ),
    );
  }
}
