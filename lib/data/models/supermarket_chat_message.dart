class SupermarketChatMessage {
  final int id;
  final String text;
  final String senderName;
  final bool isAdmin;
  final DateTime time;

  SupermarketChatMessage({
    required this.id,
    required this.text,
    required this.senderName,
    required this.isAdmin,
    required this.time,
  });
}