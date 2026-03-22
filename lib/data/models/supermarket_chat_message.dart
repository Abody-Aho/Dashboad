class SupermarketChatMessage {
  final String text;
  final String senderName;
  final bool isAdmin;
  final DateTime time;

  SupermarketChatMessage({
    required this.text,
    required this.senderName,
    required this.isAdmin,
    required this.time,
  });
}