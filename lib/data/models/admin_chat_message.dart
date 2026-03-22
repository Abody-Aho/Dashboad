class AdminChatMessage {
  final String text;
  final bool isAdmin;
  final DateTime time;

  AdminChatMessage({
    required this.text,
    required this.isAdmin,
    required this.time,
  });
}