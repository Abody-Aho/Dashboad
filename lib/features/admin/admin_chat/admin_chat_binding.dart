import 'package:get/get.dart';
import 'chat_controller.dart';

class AdminChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
          () => ChatController(),
    );
  }
}