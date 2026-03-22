import 'package:get/get.dart';
import 'supermarket_chat_controller.dart';

class SupermarketChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupermarketChatController>(
          () => SupermarketChatController(),
    );
  }
}