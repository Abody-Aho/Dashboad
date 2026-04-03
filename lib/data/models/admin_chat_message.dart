class AdminChatMessage {
  final int id;
  final String text;
  final bool isAdmin;
  final DateTime time;

  AdminChatMessage({
    required this.id,
    required this.text,
    required this.isAdmin,
    required this.time,
  });
}