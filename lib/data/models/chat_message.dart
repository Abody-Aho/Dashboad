class ChatMessage {
  final String text;
  final bool isAdmin;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isAdmin,
    required this.time,
  });
}