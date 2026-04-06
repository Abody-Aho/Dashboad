import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_link.dart';
import '../../../routes/app_routes.dart';
import '../../widgets/app_delete_dialog.dart';
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
                      Expanded(
                        child: Obx(() {
                          if (!controller.hasSelectedChat.value) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat, size: 80, color: Colors.grey.shade400),
                                  SizedBox(height: 20),
                                  Text(
                                    "مرحباً بك في شات الأدمن 👋",
                                    style: TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "اختر سوبرماركت لبدء المحادثة",
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            );
                          }

                          return _messages();
                        }),
                      ),
                      Obx(() {
                        if (!controller.hasSelectedChat.value) {
                          return const SizedBox();
                        }

                        return _input();
                      }),
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
                Get.offAllNamed(AppRoutes.dashboardAdmin);
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

          Obx(() {
            if (!controller.hasSelectedChat.value) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(Icons.chat, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "شات الأدمن",
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }

            if (controller.markets.isEmpty) {
              return const SizedBox();
            }

            final market = controller.markets[controller.selectedMarket.value];

            return Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: market.image.isNotEmpty
                      ? NetworkImage("${AppLink.image}${market.image}")
                      : null,
                  child: market.image.isEmpty
                      ? const Icon(Icons.store, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      market.getName(controller.lang),
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
                ),
              ],
            );
          }),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.searchMarkets,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "ابحث عن محادثة...",
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F5), // خلفية رمادية مخضرة خفيفة جداً ومريحة

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.green.shade600,
                    size: 20,
                  ),

                  suffixIcon: Icon(
                    Icons.tune_rounded,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),

                  contentPadding: const EdgeInsets.symmetric(vertical: 12),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.green.shade400,
                      width: 1.5,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredMarkets.length,
              itemBuilder: (context, index) {
                final market = controller.filteredMarkets[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: market.image.isNotEmpty
                        ? NetworkImage("${AppLink.image}${market.image}")
                        : null,
                    child: market.image.isEmpty
                        ? const Icon(Icons.store, color: Colors.white)
                        : null,
                  ),

                  title: Text(
                    market.getName(controller.lang),
                    style: const TextStyle(color: Constants.waText),
                  ),
                  selected: controller.selectedMarket.value == index,
                  selectedTileColor: Constants.waBorder,
                  onTap: () {
                    int realIndex = controller.markets.indexWhere(
                          (m) => m.id == market.id,
                    );
                    controller.selectMarket(realIndex);
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

  Widget _messages() {
    return Obx(() => ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.messages.length,
      itemBuilder: (context, index) {
        final msg = controller.messages[index];

        bool isMe = msg.isAdmin;

        return GestureDetector(
          onLongPress: () {
            AppDeleteDialog.show(
              title: "حذف الرسالة",
              message: "هل أنت متأكد من حذف هذه الرسالة؟",
              icon: Icons.delete_outline,
              color: Colors.red,
              onConfirm: () {
                controller.deleteMessage(
                  msg.id,
                  "admin",
                );
              },
            );
          },
          child: Align(
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
